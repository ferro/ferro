(function() {
  f.chrome_pages = {
    about: {
      prefix: 'about:',
      pages: {
        version: {
          desc: 'version, user agent, and command-line arguments'
        },
        about: {
          desc: 'about page links'
        },
        appcache_internals: {
          desc: 'application cache internals'
        },
        blob_internals: {
          desc: 'blob internals'
        },
        view_http_cache: {
          desc: 'urls in your cache'
        },
        credits: {
          desc: 'code upon which Chrome relies'
        },
        dns: {
          desc: 'dns lookups Chrome has done'
        },
        gpu: {
          desc: 'GPU info'
        },
        histograms: {
          desc: 'ASCII histograms of various stats'
        },
        memory: {
          desc: 'memory usage of each process'
        },
        net_internals: {
          desc: 'a wealth of network info'
        },
        stats: null,
        sync: null,
        tasks: null,
        tcmalloc: {
          desc: 'stats as of last page load'
        },
        terms: {
          desc: 'terms of service'
        },
        crash: {
          desc: 'kills the current page'
        }
      }
    },
    chrome: {
      prefix: 'chrome://',
      pages: {
        flags: {
          desc: 'enable experimental features'
        },
        extensions: null,
        downloads: null,
        history: null,
        settings: null,
        bookmarks: null,
        print: null,
        internets: {
          desc: 'the internets are a series of tubes'
        },
        plugins: {
          desc: 'enable/disable plugins'
        }
      }
    }
  };
}).call(this);
