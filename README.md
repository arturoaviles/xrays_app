#Para Descargar el proyecto
```
git clone https://github.com/arturoaviles/xrays_app
```

#Para Descargar los cambios que otros han hecho
```
git pull
```

#Para Agregar algo al Proyecto
```
1) git branch [name of your branch]     (Try to name it as a feature example: reminders)
2) git checkout [name of your branch]
3) Add code (Make some magic!)
```

You **fuck up** and want to **restart** what you have done?
```
git reset --hard
git checkout master
git branch -d [name of your branch]  (It deletes the branch)
git branch [name of your branch]  (Go to Step 2)
```

You app **runs**?
```
4) git status										
5) git add [files you changed] ó .						 
6) git commit -m "(Adds or Changes...)"					
7) git push origin [name of your branch]
```

You think your new feature is **well enough** to be in the master branch?
```
8) Go to: https://github.com/arturoaviles/xrays_app
9) Click Compare Pull Request
10) Select your Branch
11) Enter Title and Description
12) Click Create Pull Request
```

**The Admin will check the things you added! ;)**

What can you do next?

- You can add more things to the branch 
- You can work in another feature, just remember to:

```
git branch [name of your branch]     (Try to name it as a feature example: reminders)
git checkout [name of your branch]
```