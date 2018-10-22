# Distribute rpm package with own repository

### Task:

- create rpm package (own or for example httpd with options)
- create repository with own rpm package

### Description:

Build python project with dependencies to rpm package.

Note: standart python setup.py does not fill requires to spec file:
 - to build rpm package with dependencies were used make

There is 2 machines on vagrant:
 - server
 - client
 
Start script at the end can destroy images, to enable this behavior use option: `destroy`

##### How to:

```bash
# start demo with destroy images at the end
$ bash start.sh destroy

# or without destroy
$ bash start.sh
```