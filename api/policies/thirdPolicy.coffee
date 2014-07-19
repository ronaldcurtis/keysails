module.exports = (req, res, next) ->
  console.log('thirdPolicy here')
  next()