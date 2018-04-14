var path = require('path');
var express = require('express');
var router = express.Router();
var app = express();

app.use(express.static(path.join(__dirname, 'build')));
app.set('port', process.env.PORT || 8080);
app.set('views', __dirname + '/build');
var server = app.listen(app.get('port'), function() {
  console.log('listening on port ', server.address().port);
});


// Home page route.
router.get('/', function (req, res) {
  res.render('index.html');
router.get('/project', function (req, res) {
  res.render('project.html');
router.get('/payment', function (req, res) {
  res.render('payment.html');
  router.get('/register', function (req, res) {
  res.render('register.html');
})
