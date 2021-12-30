module.exports = {
  content: ["./dist/**/*.{html,js}"],
  theme: {
    extend: {
      boxShadow: {
        'link': 'inset 0 -.3em 0 0 #50fa7b',
      },
      colors: {
        'light': '#fafafa',
        'light-foreground': '#3e4047',
        'dracula-background': '#282a36',
        'dracula-code-bg': '#1b1d29',
        'dracula-foreground': '#f8f8f2',
        'dracula-current-line': '#44475a',
        'dracula-comment': '#6272a4',
        'dracula-cyan': '#8be9fd',
        'dracula-green': '#50fa7b',
        'dracula-orange': '#ffb86c',
        'dracula-pink': '#ff79c6',
        'dracula-purple': '#bd93f9',
        'dracula-red': '#ff5555',
        'dracula-yellow': '#f1fa8c'
      },
    },
  },
  plugins: [],
}
