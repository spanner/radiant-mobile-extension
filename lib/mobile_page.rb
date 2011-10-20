module MobilePage
  attr_accessor :mobile, :app

  # The extended site controller calls page.mobile = true if we are in a mobile context
  #
  def mobile?
    !!@mobile
  end

  # The extended site controller calls page.mobile = true if we are in a mobile context
  #
  def app?
    !!@app
  end

  include Radiant::Taggable

  desc %{
    Expands if the url of the current request matches the host name defined in Radiant::Config['mobile.host'].
    (or if there is no such definition, if the domain begins with m.) Note that if there is an app site then it will 
    also be considered mobile.

    *Usage:*
    <pre><code><r:if_mobile>...</r:if_mobile></code></pre>
  }
  tag 'if_mobile' do |tag|
    tag.expand if mobile?
  end

  desc %{
    Expands unless the url of the current request matches the host name defined in Radiant::Config['mobile.host'].
    (or if there is no such definition, unless it begins with m.) Note that if there is an app site then it will 
    also be considered mobile.

    *Usage:*
    <pre><code><r:unless_mobile>...</r:unless_mobile></code></pre>
  }
  tag 'unless_mobile' do |tag|
    tag.expand unless mobile?
  end

  desc %{
    Expands if the url of the current request matches the host name defined in Radiant::Config['app.host'].
    (or if there is no such definition, if the domain begins with app.)

    *Usage:*
    <pre><code><r:if_app>...</r:if_app></code></pre>
  }
  tag 'if_app' do |tag|
    tag.expand if app?
  end

  desc %{
    Expands unless the url of the current request matches the host name defined in Radiant::Config['app.host'].
    (or if there is no such definition, unless it begins with app.)

    *Usage:*
    <pre><code><r:unless_app>...</r:unless_app></code></pre>
  }
  tag 'unless_app' do |tag|
    tag.expand unless app?
  end

end
