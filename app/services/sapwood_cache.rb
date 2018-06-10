# frozen_string_literal: true

class SapwoodCache
  def self.enabled?
    Rails.application.config.action_controller.perform_caching
  end

  def self.rebuild_property(property)
    new.rebuild_property(property)
  end

  def self.rebuild_element(element)
    new.rebuild_element(element)
  end

  def self.delete_property(property)
    Rails.cache.delete_matched(/\_p#{property.id}\_(.*)/)
    Rails.logger.info "DELETE CACHE: [/\_p#{property.id}\_(.*)/]"
  end

  def self.delete_element(el)
    p_id = el.property.id
    # Caches on the ActiveRecord object (Element).
    Rails.cache.delete_matched(/\_p#{p_id}\_e#{el.id}\_(.*)/)
    Rails.logger.info "DELETE CACHE: /\_p#{p_id}\_e#{el.id}\_(.*)/"
    # api/elements#show
    Rails.cache.delete_matched(/\_p#{p_id}\_elements\#show\_#{el.id}\_(.*)/)
    Rails.logger.info "DELETE CACHE: /\_p#{p_id}\_elements\#show\_#{el.id}\_(.*)/"
    # api/elements#index
    Rails.cache.delete_matched(/\_p#{p_id}\_elements\#index(.*)/)
    Rails.logger.info "DELETE CACHE: /\_p#{p_id}\_elements\#index(.*)/"
  end

  def rebuild_property(property)
    return unless SapwoodCache.enabled?
    SapwoodCache.delete_property(property)
    property.elements.each { |el| el.rebuild_cache }
    property.elements.floating.each { |el| el.destroy }
  end

  def rebuild_element(element)
    return unless SapwoodCache.enabled?
    elements = element.associated_to_as_target
    # Bust the element's cache.
    SapwoodCache.delete_element(element)
    # Bust cache of element's that have this one in their associations.
    elements.each { |el| SapwoodCache.delete_element(el) }
    # Rebuild this and associated elements' as_json (without includes) cache.
    ([element] + elements).uniq.each { |el| el.rebuild_cache }
  end

  handle_asynchronously :rebuild_property
  handle_asynchronously :rebuild_element
end
