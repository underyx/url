# underyx/url

A dead-simple Docker image to run dead-simple scripts without their own image.

The image just runs your code after downloading it from a URL you specify.
It includes Bash, Python 3, and some Python packages commonly used in scripts.

## Usage

1. Write a script and make sure to include a [hashbang](https://en.wikipedia.org/wiki/Shebang_(Unix)) at the top, such as `#!/usr/bin/env python3` or `#!/usr/bin/env bash`.
2. Host your code online somewhere, such as on http://gist.github.com/ — [(example)](https://gist.github.com/underyx/fdc9bca4ab39838f239ad6f3a6ce0d8b)
3. Copy the URL to the raw code — [(example)](https://gist.githubusercontent.com/underyx/fdc9bca4ab39838f239ad6f3a6ce0d8b/raw/2a6d4e2f0e8f7c3e0eb856b98ee640acb1872609/testy)
4. Run it like so:
   ```
   docker run underyx/url https://gist.githubusercontent.com/underyx/fdc9bca4ab39838f239ad6f3a6ce0d8b/raw/2a6d4e2f0e8f7c3e0eb856b98ee640acb1872609/testy
   ```

### For periodic scripts

Rancher's [container-crontab](https://github.com/rancher/container-crontab) can run docker containers on a schedule (even if you're not using Rancher.)

Here's the docker-compose service definition I used to sync my WaniKani review count to Beeminder every hour:

```yaml
wanikani-to-beeminder:
  image: underyx/url:1
  environment:
    WANIKANI_TOKEN: <secret>
    BEEMINDER_TOKEN: <secret>
  command: [https://gist.githubusercontent.com/underyx/d35f5d304d0ef1c72c925169a0043fe8/raw/9a85ccb03d0b34eaac3fb6d8bd683ee89446a568/wk2bm.py]
  labels:
    io.rancher.container.start_once: 'true'
    cron.schedule: 55 * * * *
```

## FAQ

### Why not just save the file on a server and add it to crontab?

It's easier to use the GitHub and Rancher web UIs.

With the alternative, I'd need to drop into a terminal, deliver my locally-developed script somehow (copy-pasting into `vim`, ew), mess with a file system, and set up an isolated environment for each script or accept that I can never upgrade my dependencies when adding newer scripts. Then a couple months later I'll realize the script stopped running and I can't find its logs, which will require even more playing with the shell.

As an added bonus, I can then always access my code via a nice web app, instead of having to SSH in to a random host to read it — which I'd realistically lose after a couple years somehow, anyway.

### Isn't it inefficient to always re-download the script?

Yup! But with reasonable cron schedules, such as every ten minutes, a 20-liner script will be using like 4 bits/second of bandwidth. Both I and GitHub can afford that, surely.

And, as for latency, I can live with the two second delay this introduces, also.

### Isn't it unreliable?

Yup! But since I'm using also Docker Hub, and my self-hosted container orchestration system, running on the cheapest infrastructure provider I could find… I think GitHub is the most reliable piece of the puzzle. So, I can live with that, too.

### Isn't it unsecure?

Yup! But less so that you'd imagine. After all, the script will always run in as isolated environment, unless you're doing something weird, so remote code execution is not a huge worry.

And anyway, delivery over HTTPS should be unhijackable.
Even if someone breaks into your GitHub account, since the URL contains the commit hash of the Gist, the attackers can't sneakily edit the code whose hash you took.

## Changelog

### 3 (2018-10-01)

- Bumped Python from 3.6.4 to 3.6.6
- Bumped curl from 7.61.0 to 7.61.1
- Bumped all Python dependencies, the direct dependencies changed are:
  - `lxml`: 4.2.4 to 4.2.5
  - `slackclient`: 1.2.1 to 1.3.0

#### Shipped with

- Bash 4.4.19 and utilities:

  ```
  curl 7.61.1
  jq 1.6
  ```

- Python 3.6.6 and packages:

  ```
  arrow==0.12.1
  lxml==4.2.5
  python-dateutil==2.7.3
  pyyaml==3.13
  requests-html==0.9.0
  requests==2.19.1
  slackclient==1.3.0
  ```

### 2 (2018-08-10)

- Got rid of parent shell process (thanks @chauffer)
- Added `slackclient` Python dependency
- Bumped all Python dependencies, the direct dependencies changed are:
  - `lxml`: 4.2.3 to 4.2.4

#### Shipped with

- Bash 4.4.19 and utilities:

  ```
  curl 7.61.0
  jq 1.6
  ```

- Python 3.6.4 and packages:

  ```
  arrow==0.12.1
  lxml==4.2.4
  python-dateutil==2.7.3
  pyyaml==3.13
  requests-html==0.9.0
  requests==2.19.1
  slackclient==1.2.1
  ```

### 1 (2018-07-15)

#### Shipped with

- Bash 4.4.19 and utilities:

  ```
  curl 7.61.0
  jq 1.6
  ```

- Python 3.6.4 and packages:

  ```
  arrow==0.12.1
  lxml==4.2.3
  python-dateutil==2.7.3
  pyyaml==3.13
  requests-html==0.9.0
  requests==2.19.1
  ```
