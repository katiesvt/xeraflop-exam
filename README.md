# Pre-requisites

- Ruby version 2.4.0
- Node "Boron" LTS (version 6)

# Install

1. Fill out `config/application.yml` with your Google Maps API key
2. `bundle install`
3. `npm install`
4. `bower install`
5. `./webpack.sh`
6. `rails s`

# Excuses

- I didn't have enough time to really figure out the math behind making a working recommendation
  engine so what you'll see in there is very rudimentary. For instance, it will return multiple
  items from the same store, and it may not always find the best plan for your post-gambling binge.
- Not enough time to do the 3 different stores thing either.
- I have no idea how the THC range array works so I just assumed it was an average. I also don't
  know how any of the products are sold and if the weight can vary etc so I went by one unit of each
  item.
- Couldn't get bootstrap js integrated. A more comprehensive solution might be to completely
  abandon Sprockets in favour of Webpack's CSS, font, and image loaders.
- Didn't have time to do the additional backend requirements.
- Obviously didn't cache any APIs, be gentle so you don't get rate limited.
- In a do-over, I might separate the apps even more and go full Node/Express for the front-end and
  Rails for an API-only backend instead of having Rails serve the front-end app as well.
- You can search by any Google Maps string. I tested with Seattle, WA.
- I'm only searching for Flowers right now because there's no caching and I don't want to bring down
  or get banned from the duberex api. Also, requests already take 2 seconds and I didn't put in any
  loading indicators so it can already look like nothing's happening.
