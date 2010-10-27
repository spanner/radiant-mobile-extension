module MobilePage
  attr_accessor :mobile

  def mobile?
    !!@mobile
  end
  
  include Radiant::Taggable

  desc %{
    Expands if the url of the current request matches the host name defined in Radiant::Config['mobile.host'].
    (or if there is no such definition, if it begins with m.)

    *Usage:*
    <pre><code><r:if_mobile>...</r:if_mobile></code></pre>
  }
  tag 'if_mobile' do |tag|
    tag.expand if mobile?
  end

  desc %{
    Expands unless the url of the current request matches the host name defined in Radiant::Config['mobile.host'].
    (or if there is no such definition, unless it begins with m.)

    *Usage:*
    <pre><code><r:unless_mobile>...</r:unless_mobile></code></pre>
  }
  tag 'unless_mobile' do |tag|
    tag.expand unless mobile?
  end
end
