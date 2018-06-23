class SearchElementsService < Heartwood::Service::Base

  required_attr :property, :q

  attr_accessor :elements, :sort_by, :sort_in, :template_names

  def call
    filter_template_names
    filter_sort_args
    search_elements
    filter_elements_by_template
    sort_elements
  end

  private

    # Syntax is "template:comma,separated,list,of,templates" to filter by
    # template. If the template argument is not present, all templates will be
    # allowed.
    #
    def filter_template_names
      self.template_names = []
      q.scan(/(template:[\w,:-]+)/i).flatten.each do |match|
        # Add template name to the array of names.
        self.template_names << match.split(':')[1..-1].join(':').split(',')
        # Remove the template argument from query string.
        self.q = q.remove(match).gsub(/\ +/, ' ')
      end
      # The process above results in an array of array(s). This returns only a
      # single array for easier looping.
      self.template_names.flatten!
    end

    # Syntax is "template:comma,separated,list,of,templates" to filter by
    # template. If the template argument is not present, all templates will be
    # allowed.
    #
    def filter_sort_args
      # self.template_names = []
      q.scan(/(sort:[\w,:-]+)/i).flatten.each do |match|
        sort_parts = match.split(':').last.split(',')
        # sort_in is the first argument before the comma, which would separate
        # the field from the direction.
        self.sort_by = sort_parts.first
        # The direction is ascending unless told to be descending.
        self.sort_in = (sort_parts.last.downcase == 'desc') ? 'desc' : 'asc'
        # Remove the template argument from query string.
        self.q = q.remove(match).gsub(/\ +/, ' ')
      end
    end

    # At this point, "q" is expected to be the plain query string that can be used
    # to search element titles. If "q" is blank, we allow all elements to persist,
    # as it is assumed the search was focused on filtering by other methods.
    #
    def search_elements
      self.elements = property.elements
      self.elements = elements.search_by_title(q) if q.present?
      elements
    end

    # If there were templates in the search query, remove any without those
    # templates from the collection.
    #
    def filter_elements_by_template
      return elements if template_names.blank?
      self.elements = elements.select do |el|
        template_names.include?(el.template.name) || template_names.include?(el.template.slug)
      end
    end

    # Sort elements if the argument was passed. Otherwise give them back in the
    # order returned by the search result.
    def sort_elements
      return elements unless sort_by.present?
      elements.sort_by!(&sort_by.to_sym)
      elements.reverse! if sort_in == 'desc'
      elements
    rescue NoMethodError
      elements
    end

end
