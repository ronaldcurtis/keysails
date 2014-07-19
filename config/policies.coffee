module.exports =
  HomeController:
  	showHome: 'firstPolicy'
  PageController:
  	'*': 'firstPolicy'
  	action1: ['firstPolicy', 'secondPolicy']
  	action2: 'thirdPolicy'
