# also in src init
add_async_script = (url) ->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = url
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(ga, s)


$ ->
  $(".fancybox-thumb").fancybox({
		prevEffect: 'none'
		nextEffect: 'none'
		helpers:
			title: 
				type: 'float'
			thumbs: 
				width: 150
  })