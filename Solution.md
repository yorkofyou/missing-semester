# The Missing Semester of Your CS Education

## Course overview + the shell

### 2

```shell
cd /tmp
mkdir missing
```



### 3

touch

  Change a file access and modification times (atime, mtime).
  More information: https://www.gnu.org/software/coreutils/touch.

  - Create a new empty file(s) or change the times for existing file(s) to current time:
    touch filename
  - Set the times on a file to a specific date and time:
    touch -t YYYYMMDDHHMM.SS filename
  - Use the times from a file to set the times on a second file:
    touch -r filename filename2

### 4

```shell
cd missing
touch semester
```

### 5

```shell
#!/bin/sh
curl --head --silent https://missing.csail.mit.edu
```

The first line might be tricky to get working. It’s helpful to know that `#` starts a comment in Bash, and `!` has a special meaning even within double-quoted (`"`) strings. Bash treats single-quoted strings (`'`) differently: they will do the trick in this case. See the Bash [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) manual page for more information.

### 6

```shell
./semester
```

```shell
zsh: permission denied: ./semester
```

```shell
ls -l
```

```shell
total 8
-rw-r--r--  1 yorkyou  staff  61 May 30 22:35 semester
```

No permission to execute the file on my own.

### 7

```shell
sh semester
```

```shell
HTTP/2 200
server: GitHub.com
content-type: text/html; charset=utf-8
last-modified: Fri, 21 May 2021 12:05:33 GMT
access-control-allow-origin: *
etag: "60a7a20d-1f31"
expires: Sun, 30 May 2021 14:55:11 GMT
cache-control: max-age=600
x-proxy-cache: MISS
x-github-request-id: ED24:70A7:D3EC9:F61B6:60B3A4F7
accept-ranges: bytes
date: Sun, 30 May 2021 14:45:11 GMT
via: 1.1 varnish
age: 0
x-served-by: cache-hkg17931-HKG
x-cache: MISS
x-cache-hits: 0
x-timer: S1622385911.318669,VS0,VE252
vary: Accept-Encoding
x-fastly-request-id: 9899eb509df283d29a3bae3dbac4f0279515c186
content-length: 7985
```

> - `./script.sh` makes your shell run the file as if it was a regular executable.
>
>   The shell forks itself and uses a system call (e.g. `execve`) to make the operating system execute the file in the forked process. The operating system will check the file's permissions (hence the execution bit needs to be set) and forward the request to the [program loader](http://en.wikipedia.org/wiki/Loader_(computing)), which looks at the file and determines how to execute it.
>
> - `bash script.sh` makes your shell run `bash` and pass `script.sh` as the command-line argument.
>
>   The operating system will load `bash` (not even looking at `script.sh`, because it's just a command-line argument). The created `bash` process will then interpret the `script.sh` because it's passed as the command-line argument. Because `script.sh` is only read by `bash` as a regular file, the execution bit is not required.

### 9

```shell
chmod u+x semester
./semester
```

```shell
HTTP/2 200
server: GitHub.com
content-type: text/html; charset=utf-8
last-modified: Fri, 21 May 2021 12:05:33 GMT
access-control-allow-origin: *
etag: "60a7a20d-1f31"
expires: Sun, 30 May 2021 14:55:11 GMT
cache-control: max-age=600
x-proxy-cache: MISS
x-github-request-id: ED24:70A7:D3EC9:F61B6:60B3A4F7
accept-ranges: bytes
date: Mon, 31 May 2021 00:47:20 GMT
via: 1.1 varnish
age: 0
x-served-by: cache-hkg17930-HKG
x-cache: HIT
x-cache-hits: 1
x-timer: S1622422040.488156,VS0,VE260
vary: Accept-Encoding
x-fastly-request-id: 3cf83ff73737586b2415dd6438e152ce31f3ba26
content-length: 7985
```

### 10

```shell
./semester | grep last-modified > ~/last-modified.txt
```

## Shell Tools and Scripting

### 1

```shell
ls -ahltG
```

### 2

```shell
#!/bin/zsh

macro() {
	MACRO=$(pwd)
}

polo() {
	cd "$MACRO"
}
```

### 3

```shell
count=1

while true
do
    ./script.sh 2> out.log
    if [[ $? -ne 0 ]]; then
        echo "failed after $count times"
        cat out.log
        break
    fi
    ((count++))

done

```

#### 4

```shell
find . -name '*.html' -print0 | xargs -0 tar -vcf html.zip
```

### 5

```shell
find . -type f -print0 | xargs -0 ls -lt | head -1
```

## Editors (Vim)

### 1

```shell
vimtutor
```

### 6

[Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en)

[vscodevim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim)

[IdeaVim](https://plugins.jetbrains.com/plugin/164-ideavim)

[jupyterlab-vim](https://pypi.org/project/jupyterlab-vim/)

zsh

```shell
# Enable vi mode
bindkey -v
```

### 8

1. dd
2. Gdd
3. gg^
4. qwc${<ESC>wv5lc"name": "<ESC>/<<Enter>v6lc,<ESC>wv6lc"email": "<ESC>/<<Enter>v7lc"wc$},<ESC>wq
5. 999@q
6. ggO{
7. Go}

## Data Wrangling

### 2

```shell
grep -E '(a.*){3}[^s]$' /usr/share/dict/words | wc -l
grep -E '(a.*){3}[^s]$' /usr/share/dict/words | sed -E 's/(.*(..))/\2/' | sort | uniq -c | sort -nk1,1 | tail -n3
grep -E '(a.*){3}[^s]$' /usr/share/dict/words | sed -E 's/(.*(..))/\2/' | sort | uniq -c | awk '{print $2}' > occurrence.txt | printf '%s\n' {a..z}{a..z} > all.txt | diff --unchanged-group-format='' <(cat occurrence.txt) <(cat all.txt) | wc -l
```

### 3

```shell
sed -i s/REGEX/SUBSTITUTION/ input.txt > input.txt
```

### 4

```shell
journalctl | grep "Startup finished" | sed -E "s/^.*Startup finished in ([0-9]+\.?[0-9]*)m?s.*$/\1/" | tail -n10 | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

### 5

```shell
for i in 1 2 3; do journalctl -b-$i | grep "Startup finished" ;done | sed -E "s/.*in\ (.*)/\1/" | sort | uniq -c | sort | awk '$1<3 { print }'
```

### 6

```shell
curl -s https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm | pup 'table#table1 json{}' | jq '.[0].children[0].children[12:-3][] | .children[1].text' | sed -E 's/\"([0-9]+)\"/\1/g' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
curl -s https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm | pup 'table#table1 json{}' | jq '.[0].children[0].children[12:-3][] | .children[2].text' | sed -E 's/\"([0-9]+)\"/\1/g' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

## Command-line Environment

**Job Control**

### 1

```shell
sleep 10000
<Ctrl-Z>
bg
pgrep -af sleep
pkill -af sleep
```

### 2

```shell
sleep 60 &
wait %1
ls
```

**Alias**

### 1

```shell
alias dc="cd"
```

**Remote Machines**

### 2

```shell
ssh -L 9999:localhost:8888 my_server
```

### 5

```shell
ssh -fN -L 9999:localhost:8888 my_server
```
