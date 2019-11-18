Load testing/simulating traffic with [loader.io](https://devcenter.heroku.com/articles/loaderio#installing-the-loader-io-add-on)

1. `git clone` this repo
2. `cd` into the repo
3. `git checkout -b add-loaderio`
4. `heroku addons:create loaderio:basic -a whatever-you-named-your-app`
5. `heroku addons:open loaderio -a whatever-you-named-your-app`
6. Click the Target Hosts tab and add your app URL as a new target. 
7. Once added, you will be prompted to download a verification text file. Download that and add it to the `public` folder of your local repo.
8. `git add public/name-of-your-file.txt`
9. `git commit -am "Add verification text file for loader.io"` to commit the file to local Git repo
10. `heroku git:remote -a whatever-you-named-your-app` to set `heroku` as the remote destination for your local repo
11. `git push heroku add-loaderio:master` to [deploy your local add-loaderio branch](https://devcenter.heroku.com/articles/git#deploying-from-a-branch-besides-master) to Heroku.
12. Back in loader.io, you should now be able to click the Verify button for the Target Host and get a success.
13. Set up tests. See their [docs](https://support.loader.io/article/15-creating-a-test) for more info.