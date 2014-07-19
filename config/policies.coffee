module.exports =
  HomeController:
  	showHome: 'firstPolicy'
  PageController:
  	'*': 'firstPolicy'
  	showPage: ['secondPolicy', 'thirdPolicy']
  	action2: 'thirdPolicy'
