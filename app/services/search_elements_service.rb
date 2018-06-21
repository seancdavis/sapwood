# frozen_string_literal: true

class SearchElementsService < Heartwood::Service::Base

  required_attr :property, :q

  attr_accessor :elements, :template_names

  def call
    filter_template_names
    search_elements
    filter_elements_by_template
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
      self.elements = elements.select { |el| template_names.include?(el.template.name) }
    end

end
