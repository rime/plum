<meta charset="UTF-8">

La brise: 東風破
===
Rime schema repository

Project home
---
[rime.im](http://rime.im)

License
---
GPLv3

Individual packages in this collection can be released under different licenses.
Please refer to their respective LICENSE files.

Contents
===
This software is a collection of data packages used by [Rime](http://rime.im)
to support various Chinese input methods, including those based on modern
dialects or historical diasystems of the Chinese language.

A **Rime input schema** describes the behaviors of a specific input method
in Rime's DSL. It consists of a configuration file named `*.schema.yaml` where
`*` is schema ID, and an optional **Rime dictionary** file named `*.dict.yaml`.

A package may contain one or several interrelated input schemata and their
affiliated Rime dictionaries.

Packages
===

Essentials
---

  - [`prelude`](https://github.com/rime/rime-prelude): the prelude package, providing Rime's default settings
  - [`essay`](https://github.com/rime/rime-essay): 八股文 / a shared vocabulary and language model

Phonetic-based input methods
---
Modern Standard Madarin

  - [`luna-pinyin`](https://github.com/rime/rime-luna-pinyin): 朙月拼音 / Pinyin in Tranditional Chinese
  - [`terra-pinyin`](https://github.com/rime/rime-terra-pinyin): 地球拼音 / School-taught Pinyin, with tone marks
  - [`bopomofo`](https://github.com/rime/rime-bopomofo): 注音 / Zhuyin (aka. Bopomofo)
  - [`pinyin-simp`](https://github.com/rime/rime-pinyin-simp): 袖珍簡化字拼音 / Pinyin in Simplified Chinese

Derivatives of Pinyin

  - [`double-pinyin`](https://github.com/rime/rime-double-pinyin): 雙拼 / Double Pinyin (ZiRanMa, ABC, flyPY, MSPY, PYJJ variants)
  - [`combo-pinyin`](https://github.com/rime/rime-combo-pinyin): 宮保拼音 / Chord-typing Pinyin
  - [`stenotype`](https://github.com/rime/rime-stenotype): 打字速記法 / a stenographic system derived from ABC Easy Shorthand

Other modern varieties of Chinese

  - [`jyutping`](https://github.com/rime/rime-jyutping): 粵拼 / Cantonese
  - [`wugniu`](https://github.com/rime/rime-wugniu): 上海吳語 / Wu (Shanghainese)
  - [`soutzoe`](https://github.com/rime/rime-soutzoe): 蘇州吳語 / Wu (Suzhounese)

Middle Chinese

  - [`middle-chinese`](https://github.com/rime/rime-middle-chinese): 中古漢語拼音 / Middle Chinese Romanization

Shape-based input methods
---

  - [`stroke`](https://github.com/rime/rime-stroke): 五筆畫 / five strokes
  - [`cangjie`](https://github.com/rime/rime-cangjie): 倉頡輸入法 / Cangjie input method
  - [`quick`](https://github.com/rime/rime-quick): 速成 / Simplified Cangjie
  - [`wubi`](https://github.com/rime/rime-wubi): 五筆字型
  - [`array`](https://github.com/rime/rime-array): 行列輸入法
  - [`scj`](https://github.com/rime/rime-scj): 快速倉頡

Miscelaneous
---

  - [`emoji`](https://github.com/rime/rime-emoji): 繪文字 / input emoji with English or Chinese Pinyin keywords
  - [`ipa`](https://github.com/rime/rime-ipa): 國際音標 / International Phonetic Alphabet

Usage
===

To prepare your Rime configuration for [Squirrel](https://github.com/rime/squirrel),
[Weasel](https://github.com/rime/weasel) or
[ibus-rime](https://github.com/rime/ibus-rime), you can get started by running

```sh
curl -fsSL https://git.io/v13uY | bash
```

This runs the `rime-install` script to download preset packages and install
source files to Rime user directory. (yet it doesn't enable new schemas for you)

Alternatively, you can specify a configuration among `:preset`, `:extra` and
`:all` (note the colon):

```sh
curl -fsSL https://git.io/v13uY | bash -s -- :preset
```

This is equivalent to cloning this repo and running `rime-install`:

```sh
git clone --depth 1 https://github.com/rime/brise.git
cd brise
bash rime-install :preset
```

You can then add packages from great Rime developers on GitHub by specifying a
list of package names or `user/repo`:

```sh
bash rime-install middle-chinese lotem/rime-zhung acevery/rime-zhengma
```

For third-party Rime distributions, specify the path to Rime user directory in
the command line:

```sh
rime_dir=$HOME/.config/fcitx/rime bash rime-install
```

To update la brise itself, run

```sh
bash rime-install update
```

Install
===

The Makefile builds and installs Rime data as a binary package on Unix systems.

Build dependencies
---

- git
- librime>=1.3 (for `rime_deployer`)

Run-time dependencies
---

  - librime>=1.3
  - opencc>=1.0.2

Build and install
---

The default make target uses `git` command line to download the latest packages
from GitHub.

```sh
make
sudo make install
```

You can optionally build YAML files to binaries by setting the shell variable
`BRISE_BUILD_BINARIES`. To build preset packages, do

```sh
BRISE_BUILD_BINARIES=yes make preset
```

Credits
===
We are grateful to the makers of the following open source projects:

  - [Android Pinyin IME](https://source.android.com/) (Apache 2.0)
  - [Chewing / 新酷音](http://chewing.im/) (LGPL)
  - [ibus-table](https://github.com/acevery/ibus-table) (LGPL)
  - [OpenCC / 開放中文轉換](https://github.com/BYVoid/OpenCC) (Apache 2.0)
  - [moedict / 萌典](https://www.moedict.tw) (CC0 1.0)
  - [Rime 翰林院 / Rime Academy](https://github.com/rime-aca) (GPLv3)

Also to the inventors of the following input methods:

  - Cangjie / 倉頡輸入法 by 朱邦復
  - Array input method / 行列輸入法 by 廖明德
  - Wubi / 五筆字型 by 王永民
  - Scj / 快速倉頡 by 麥志洪
  - Middle Chinese Romanization / 中古漢語拼音 by 古韻

Contributors
===
The repository is a result of collective effort. It was set up by the following
people by contributing files, patches and pull-requests. See also the
[contributors](https://github.com/rime/brise/graphs/contributors) page for a
list of open-source collaborators.

  - [佛振](https://github.com/lotem)
  - [Kunki Chou](https://github.com/kunki)
  - [雪齋](https://github.com/LEOYoon-Tsaw)
  - [Patrick Tschang](https://github.com/Patricivs)
  - [Joseph J.C. Tang](https://github.com/jinntrance)
  - [lxk](http://101reset.com)
  - [Ye Zhou](https://github.com/zhouye)
  - Jiehong Ma
  - StarSasumi
  - 古韻
  - 寒寒豆
  - 四季的風
  - 上海閒話abc
  - 吳語越音

Contributing
===
Pull requests are welcome for established, open-source input methods that
haven't been included in the repository. Thank you!
But you'll be responsible for providing source files along with an open-source
license because licensing will be rigidly scrutinized by downstream packagers.
