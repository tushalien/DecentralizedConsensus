const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './app/js/app.js',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'app.js'
  },
  plugins: [
    new CopyWebpackPlugin([
      { from: './app/index.html', to: "index.html" },
      { from: './app/project.html', to: "project.html" },
      { from: './app/payment.html', to: "payment.html" }
          ])
  ],
  module: {
    rules: [
      {
          test: /\.(jpe?g|png|gif|svg|woff|woff2|eot|ttf)$/i,  // a regular expression that catches .js files
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
