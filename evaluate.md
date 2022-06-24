# YAP Evaluation Package

## Download and Prerequisites
```
git clone https://github.com/ytzemih/yap.git
```

Make sure you have [`Docker`](https://docs.docker.com/get-docker/) (if
you are using Ubuntu 20.04 have a look at [this installation
guide](https://phoenixnap.com/kb/install-docker-on-ubuntu-20-04)) and
[`docker-compose`](https://docs.docker.com/compose/install/)
installed.  You will need about **2.5GiB of disk space** to store 
the built Docker image.

## Building the Docker Image

### ... with `make`
Run
 - `make` to build the container and execute the example workflow.
 - `make shell` to build and get a shell inside the container.
 - `make build` to build the container.
 - `make clean` to remove previous workflow artefacts.
### ... manually (without `make`)
Run
```bash
$ docker-compose up
```
to build and run the container.

If you just want to build the container, run:
```bash
$ docker-compose build
```

## Workflow Artefacts
Obtain the workflow result from the `files/yap-examples/hrc2/`
directory.  You can find the test log of the final workflow stage in
the `06-test` subfolder:
 - `cat files/yap-examples/hrc2/06-tests/workcell_failures.log` should
   output `0`, meaning that zero errors have been found
 - `cat files/yap-examples/hrc2/06-tests/workcell_results-h-0.log`
   should only contain `PASS` verdicts.

## Known Issues
 - If, for any reason, your Docker setup is [unable to access the
   Ubuntu package
   repositories](https://medium.com/@faithfulanere/solved-docker-build-could-not-resolve-archive-ubuntu-com-apt-get-fails-to-install-anything-9ea4dfdcdcf2),
   please, try to restart `sudo service docker restart` to make sure
   DNS is properly working.
 - If the workflow exhibits errors, e.g. killed processes, please make
   sure the docker container has **at least 4GB of memory** available.  If
   you are using Docker Desktop on macOS or Windows you may need to
   increase the system resources in the Preferences page.
