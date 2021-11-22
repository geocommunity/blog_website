---
title: Creating a geospatial blog with Blogdown
author: Stephane Guillou and Mitchel Rudge
date: '2021-10-28'
slug: creating-a-geospatial-blog-with-blogdown
categories: []
tags:
  - r
  - rstudio
  - git
  - blogdown
---


### Good resources
+ https://www.apreshill.com/blog/2020-12-new-year-new-blogdown/
+ https://www.youtube.com/watch?v=x-Ch0-w1UhY
+ https://solomonkurz.netlify.app/post/2021-05-03-blogdown-updates-prompted-a-website-overhaul-these-are-my-notes/
+ https://bookdown.org/yihui/blogdown/installation.html

### Prerequisites
-	Fairly recent version of R studio (RStudio IDE version, v1.4.1106 +)
-	Github account
*	GIT locally on computer. (Happy git with R https://happygitwithr.com/)     
    + gitforwindows.org
    + Download GNU
    + Default on all settings
	Make sure to select Git from the command line and also from 3rd party software
-	Sign up for Netlify using Github account

### Steps

# 1.	Create a new github repository
Initialise with readme, but don't add the .gitignore file. Then copy link https link. 

# 2.	Create a new project in R studio
In R studio, go to File > new project > Version control > git, and Paste the URL from before. Save the project somewhere sensible. 

Now install blogdown with Install.packages(“blogdown”), and load with library(blogdown). 


```r
install.packages("blogdown")
library(blogdown)
```


Now to create a new site, just add


```r
new_site()
```

This will give the default theme, but there are a lot of different themes to choose from! 

https://themes.gohugo.io/ 

Its important to find one that you like, but also that is up to date and works. For this blog, we ended up going with https://themes.gohugo.io/themes/anatole/ over some other options which were buggy, probably due to being out of date. 

So to build the site with your theme of choice, run


```r
new_site(theme = "lxndrblz/anatole")
```

<<<<<<< HEAD
Adding theme= "gighubusername/themerepo" of the theme you choose. 

When prompted, select y to let blogdown start a server. This will let you preview the site in the viewer. To view in a browser, click the show in new window (next to the broom) to launch it locally. 




=======
Replacing the gighub username/themerepo name that you choose. 


.	choose a theme https://themes.gohugo.io/
ii.	“knadh/hugo-ink”
iii.	pacollins/hugo-future-imperfect-slim
d.	select y to let blogdown start a server for us. 
e.	blogdown::serve_site() #to serve site locally Click “show in new window” to properly preview
>>>>>>> 6fb62a956183ccb9efafec5aedc60b035984af38
f.	There are two types of R markdown posts
i.	.Rmd to .html 
ii.	.Rmarkdown to .markdown (recommend .Rmarkdown)
g.	blogdown::new_post(title = "First post", ext = '.Rmarkdown', subdir = "post") #usually post but sometimes posts
h.	Can save a bunch of settings using
options(
  # to automatically serve the site on RStudio startup, set this option to TRUE
  blogdown.serve_site.startup = FALSE,
  # to disable knitting Rmd files on save, set this option to FALSE
  blogdown.knit.on_save = FALSE     <- change
  blogdown.author = "Alison Hill",  <- add
  blogdown.ext = ".Rmarkdown",      <- add
  blogdown.subdir = "post"          <- add
)
Restart R
i.	click the knit button
j.	Add R code chunk ‘’’{r}  
Summry(Orange)
‘’’
Then knit. 

Add more code. 

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-1.png" width="672" />
k.	If its not working, try blogdown::check_site() and get it fixed
4.	Using GitHub
a.	file.edit(“.gitignore”)
b.	Add 
.Rproj.user
.Rhistory
.RData
.Ruserdata
.DS_Store
Thumbs.db 
/public/
/resources/



c.	Blogdown::check_gitignore()
d.	Now check content
i.	blogdown::check_content()
ii.	

e.	the initial stage might not work, so do it through the shell. 
i.	Tools > shell 
Can configure git if it didn’t do it with a token. 
Git config –global user.name “username from github”
Git config –global user.email “email from github”
Then to stage all, git add -A
d
Commit > commit comment > push
5.	Publish site
a.	Sign up to Netlify using your GitHub account
b.	New Site from Git > Continuous Deployment: GitHub
c.	Select deploy site. Now it will automatically update every time you push changes to github
d.	Change site name general > site details > change site name
e.	Rstudioapi::navigateToFile(“config.yaml”, line = 3) make sure correct site name
f.	Blogdown::check_netlify()
i.	Select option 1
-	
