const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: ['./app/js/app.js','./app/js/materialize.js','./app/js/init.js'],
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'app.js'
  },
  plugins: [
    new CopyWebpackPlugin([
      { from: './app/index.html', to: "index.html" },
      { from: './app/project.html', to: "project.html" },
      { from: './app/payment.html', to: "payment.html" },
      { from: './app/dispute.html', to: "dispute.html" },
      { from: './app/myproject.html', to: "myproject.html" },
            { from: './app/owner.html', to: "owner.html" },
       { from: './app/register.html', to: "register.html" }
          ])
  ],
  module: {
    rules: [
      {
          test: /\.(jpeg|png|gif|jpg|svg|woff|woff2|eot|ttf)$/i,  // a regular expression that catches .js files
          exclude: /node_modules/,
          loader: 'url-loader',
      }    
    ,
      {
       test: /\.css$/,
       use: [ 'style-loader', 'css-loader' ]
      }
    ],
    loaders: [
      { test: /\.json$/, use: 'json-loader' },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel-loader',
        query: {
          presets: ['es2015'],
          plugins: ['transform-runtime']
        }
      }
    ]
  }
}
