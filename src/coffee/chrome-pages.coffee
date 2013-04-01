chrome_pages =
  version: 'version, user agent, and command-line arguments'
  about: 'about page links'
  appcache_internals: 'application cache internals'
  blob_internals: 'blob internals'
  view_http_cache: 'urls in your cache'
  credits: 'code upon which Chrome relies'
  dns: 'dns lookups Chrome has done'
  gpu: 'GPU info'
  histograms: 'ASCII histograms of various stats'
  memory: 'memory usage of each process'
  net_internals: 'a wealth of network info'
  stats: null
  sync: null
  tasks: null
  tcmalloc: 'stats as of last page load' #todo
  terms: 'terms of service'
  crash: 'kills the current page'
  flags: 'enable experimental features'
  extensions: null
  downloads: null
  history: null
  settings: null
  bookmarks: null
  print: null
  internets: 'the internets are a series of tubes'
  plugins: 'enable/disable plugins'

SPECIAL_PAGES = []

for name, desc of chrome_pages
  SPECIAL_PAGES.push
    name: name
    desc: desc
    url: 'chrome://' + name.replace('_', '-')

