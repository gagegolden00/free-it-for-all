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
    extend: {
      colors: {
        'primary': {
          DEFAULT: '#1375BC',
          50: '#B8DDF8',
          100: '#A5D4F6',
          200: '#80C2F2',
          300: '#5BB0EE',
          400: '#369FEB',
          500: '#178CE1',
          600: '#1375BC',
          700: '#0E5589',
          800: '#093656',
          900: '#041623',
          950: '#01060A'
        },

        'secondary': {
          DEFAULT: '#3673B7',
          50: '#D9E6F4',
          100: '#CADBEF',
          200: '#AAC6E6',
          300: '#8BB1DD',
          400: '#6B9CD3',
          500: '#4C87CA',
          600: '#3673B7',
          700: '#29588C',
          800: '#1C3D60',
          900: '#102135',
          950: '#09141F'
        },
      }
    }
  }
}
