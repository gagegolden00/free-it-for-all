module.exports = {
  plugins: [
    require('flowbite/plugin')
  ],

  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*.html.erb',
    './node_modules/flowbite/**/*.js'
  ],

  theme: {
    colors: {
      'primary': '#3673B7'
    }
  }
}
