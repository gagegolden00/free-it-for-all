module.exports = {
  important: true,
  plugins: [
    require('flowbite/plugin')
  ],

  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*.html.erb',
    './app/components/**/*.rb',
    './node_modules/flowbite/**/*.js'
  ],

  theme: {
    extend: {
      colors: {

        'primary': {
          DEFAULT: '#222831',
          50: '#6F819B',
          100: '#657791',
          200: '#546379',
          300: '#434F61',
          400: '#333C49',
          500: '#222831',
          600: '#0B0D10',
          700: '#000000',
          800: '#000000',
          900: '#000000',
          950: '#000000'
        },

        'secondary': {
          DEFAULT: '#EEEEEE',
          50: '#FFFFFF',
          100: '#FFFFFF',
          200: '#FFFFFF',
          300: '#FFFFFF',
          400: '#FFFFFF',
          500: '#EEEEEE',
          600: '#D2D2D2',
          700: '#B6B6B6',
          800: '#9A9A9A',
          900: '#7E7E7E',
          950: '#707070'
        },



        'gray': {
          DEFAULT: '#393E46',
          50: '#9199A6',
          100: '#868F9C',
          200: '#707A89',
          300: '#5E6673',
          400: '#4B525C',
          500: '#393E46',
          600: '#202327',
          700: '#070708',
          800: '#000000',
          900: '#000000',
          950: '#000000'
        },

        'teal': {
          DEFAULT: '#00ADB5',
          50: '#6EF9FF',
          100: '#59F8FF',
          200: '#30F6FF',
          300: '#08F4FF',
          400: '#00D4DE',
          500: '#00ADB5',
          600: '#00777D',
          700: '#004245',
          800: '#000C0D',
          900: '#000000',
          950: '#000000'
        }
      }
    }
  }
}
