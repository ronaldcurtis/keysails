module.exports = (req, res, next) ->
  console.log('secondPolicy here')
  next()