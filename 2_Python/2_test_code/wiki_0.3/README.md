
# [Basic wiki in 0.3](http://webpy.org/src/wiki/0.3)

## create source code
    $ tree wiki_0.3
    ```
        wiki_0.3
        ├── model.py
        ├── README.md          # add by sfoolish
        ├── requirements.txt   # add by sfoolish
        ├── schema.sql
        ├── templates
        │   ├── base.html
        │   ├── edit.html
        │   ├── index.html
        │   ├── new.html
        │   └── view.html
        └── wiki.py
    ```

## create database
    $ mysql -h 127.0.0.1 -u username -p
    mysql> create database wiki
    mysql> use wiki
    mysql> source ./wiki_0.3/schema.sql

## create virtual env
    $ virtualenv --distribute wiki_virt
    $ source wiki_virt/bin/activate
    $ pip install -r wiki_0.3/requirements.txt

## edit model.py to config database
    
    db = web.database(dbn='mysql', user='username', pw='password', db='dbname')

## run wiki
    $ python wiki.py

## REF

### [Create database][1]
Create database with file './game-server/config/schema/Pomelo.sql'.

    * Install mysql database
    * Login database: mysql -uUsername -pPassword
    * Create database: mysql> create database Pomelo
    * Choose database: mysql> use Pomelo
    * Import sql file: mysql> source ./game-server/config/schema/Pomelo.sql
[1]:https://github.com/NetEase/pomelo/wiki/Installation-guide-of-lordofpomelo#create-database
