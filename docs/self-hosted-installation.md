# Installing Sapwood On Production Server

Currently, the only offering of Sapwood is as a self-hosted application. Sapwood 2 has reduced the number of steps needed for a standard installation, to make it a little smoother to get up and running!

This guide is going to walk through the steps for a standard installation. Veering from the recommended settings is fine, but it is not supported.

## 01: Find A Dedicated Server

First thing is first -- find yourself a dedicated private server. A super great (and cheap) option is [Digital Ocean](https://www.digitalocean.com/).

**Please note the following:**

- Sapwood is only supported on Ubuntu 14.04.
- 512 MB of RAM _has_ worked, but 1 GB (or more) is recommended.

## 02: Install Software

Next, let's get your server ready.

I **highly recommend** using [Ripen](https://github.com/seancdavis/ripen) (or similar) to manage the installation of your server software.

We'll assume you have a `sapwood` user with `sudo` privileges and a home directory at `/home/sapwood`.

To be able to install Sapwood, you'll want the following packages:

- `build-essential`
- `imagemagick`
- `libmagic-dev`
- `libmagickwand-dev`
- `libreadline-gplv2-dev`
- `libssl-dev`
- `libxml2-dev`
- `libxml2`
- `libxslt1-dev`
- `make`
- `nodejs`
- `python-software-properties`
- `zlib1g-dev`

And then you can install these programs:

- [Git](http://git-scm.com/)
- [Nginx](http://nginx.org/)
- [PostgreSQL Server](http://www.postgresql.org/)
- [Ruby](https://www.ruby-lang.org/en/) 2.2.3
- [Bundler](http://bundler.io/)

> Note: It's never a bad idea to lock down SSH and take some other security measures. [Here's a good article](http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers) that goes through some "essential security" practices.

And whenever you're done installing, it's a good idea to check everything you've done. Make sure `sapwood` is the owner of everything in their home directory:

```text
$ chmod -R sapwood:sapwood /home/sapwood
```

And make sure you can ssh into the server as the `sapwood` user.

## 03: Setup Amazon AWS

Sapwood is configured to upload directly to Amazon AWS. This is so we keep upload traffic off your server to serve data to your external applications quicker.

These steps point to some of Amazon's documentation, as opposed to walking you through each step. It's a good idea to become familiar with Amazon S3 if you aren't already. That will require some time and reading on their site.

Begin by [creating an account](http://docs.aws.amazon.com/AmazonS3/latest/gsg/SigningUpforS3.html) at [Amazon AWS](https://aws.amazon.com/) if you don't already have one.

Once you have an account, [create an IAM user with admin permissions](http://docs.aws.amazon.com/IAM/latest/UserGuide/console.html). Typically I create a user, then add them to an Admin group which has admin permissions. I use a packaged permission policy called _AdministratorAccess_. Amazon has a nice policy generator to help with this.

Next, [create an S3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html). Call it whatever you'd like, but **make sure it's in the _US Standard_ region.**

Last thing is we need to make sure we can upload to the bucket, so we need to [edit the CORS configuration](http://docs.aws.amazon.com/AmazonS3/latest/dev/cors.html) to look like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>PUT</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

Keep your IAM credentials, and your bucket name handy for installation.

## 04: Setup SendGrid

The other third-party service you'll need to work with is [SendGrid](http://sendgrid.com/). Instead of worrying about configuring servers to send emails, Sapwood relies on SendGrid for delivering email messages.

You'll want to create an account with SendGrid and keep your username, password, and domain handy.

## 05: Configure Domain

Last thing before we move on to the actual application is to configure a domain to point to Sapwood. All you'll need is the IP address of the server on which Sapwood is going to operate. Then point an A-record of your domain to that IP address.

## 06: Install Sapwood

Now we can move on to installing Sapwood.

Make sure you are logged in as the `sapwood` user and change into that directory.

```text
$ cd /home/sapwood
```

Then let's clone the sapwood project.

```text
$ git clone https://github.com/seancdavis/sapwood.git
```

Before we can run the installation wizard, the one thing we need to do is install our gems. This may take a few minutes.

```text
$ cd /home/sapwood/sapwood
$ bundle install --without development test
```

The low-level installation is all wrapped up in a rake task.

**Be sure to read the prompts carefully and to fill them all out.**

```text
$ bundle exec rake sapwood:install
```

If this went according to plan, then you'll see a message at the end telling you to visit your domain name to finish the installation process.

The app's Installation Wizard will get you started with an admin user, and that's also where you'll fill in your SendGrid and Amazon AWS credentials.

## Issues?

As always, if you run into issues during this process, please [create an issue on GitHub](https://github.com/seancdavis/sapwood/issues/new).
