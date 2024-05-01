#!/bin/bash
mkdir src
./obsidian-export ~/file/github/obsidian/技术 ./src --no-recursive-embeds

cp ~/file/github/obsidian/readme.md ./src/README.md
echo -e "\n---\n## Update Time\n- last update in `date`" >> ./src/README.md

# choose one
# vim ./src/SUMMARY.md -c ":for v in split(mdbook#MkbookFile('./src'),'\n')|call append(line('.')-1,v)|endfor" -c ":wq"
./update.py src

mdbook build
rm -rf src
