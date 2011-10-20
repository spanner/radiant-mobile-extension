# Mobile

This very simple extension allows you to offer a cache-friendly mobile version of your radiant site.

## Basic usage

1. Any request to a host whose address begins 'm.' is considered to be a request for the mobile site. If you want to use a different address, put its hostname in 'mobile.host'. You can do that through the admin settings interface.

2. Set 'mobile.redirect?' to true and put the full hostname in 'mobile.hostname' if you want to bounce iphone and other mobile users to your mobile site when they first arrive.

3. Provide a link back to your main site by appending ?nomobile. We will skip the redirect on that request and set a session flag that will carry on blocking it for future requests.

4. Use the radius tags `<r:if_mobile_>` and `<r:unless_mobile>` to make layout or content decisions based on whether this is a request for the mobile site.

## Web views

Any request that whose address begins 'app.', or which matches the configured 'app.host' is considered to be a request from a smartphone app for a web view. Such requests will set the mobile flag and will also set an app flag, so you can use an additional `<r:if_app>` radius tag to distinguish such requests from normal mobile phone usage.

## Possibly AQ

### Why not just set :format (or use mobile-fu)?

* Because radiant renders pages within the model, using layouts chosen by association. The rails layout is always the same and there is no show-page template in the usual sense.

### Why not just detect mobile devices?

* We can give visitors more control this way.
* We can't deliver variant pages through the cache: different versions of the same page must have different addresses.

## Building a mobile site

It's up to you how broadly the mobile context affects your site delivery. Here are some likely scenarios:

### Omitted content

	<r:unless_mobile>
	  <r:content part="sidebar" />
	<r:unless_mobile>

### Different CSS

	<r:if_mobile>
	  <r:stylesheet slug="mobile.css" as="link" />
	</r:if_mobile>
	<r:unless_mobile>
	  <r:stylesheet slug="standard.css" as="link" />
	<r:unless_mobile>

### Different content

	<r:if_mobile>
	  <r:content part="iphone" />
	</r:if_mobile>
	<r:unless_mobile>
	  <r:content />
	<r:unless_mobile>

### Different page components

	<r:if_mobile>
	  <r:snippet name="mobile_masthead" />
	</r:if_mobile>
	<r:unless_mobile>
	  <r:snippet name="standard_masthead" />
	</r:unless_mobile>

### Different layout

With the `layouts` or `nested_layouts` extension you could create a simple layout-chooser layout. I haven't tried it, but this ought to work:

	<r:if_mobile>
	  <r:inside_layout name="Mobile">
	    <r:content_for_layout />
	  </r:inside_layout>
	</r:if_mobile>
	<r:unless_mobile>
	  <r:inside_layout name="Standard">
	  	<r:content_for_layout />
	  </r:inside_layout>
	</r:unless_mobile>

## Status

This has been in use for a couple of years without problems. The app-view part is new but ordinary: you should be able to use this extension with confidence.

## Bugs and comments

Github issues, please, or write to Will.

## Author and copyright

* Copyright spanner ltd 2010.
* Released under the same terms as Rails and/or Radiant.
* Contact will at spanner.org

