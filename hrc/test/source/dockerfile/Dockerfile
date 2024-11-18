# FROM ...

FROM image
FROM repo/image
FROM image:tag
FROM image@digest
FROM image:tag@digest
FROM repo/image:tag@digest
FROM image AS name
FROM image as name
FROM --platform image
FROM --platform \
    --foo --bar=xxx
FROM --platform=platform
FROM --platform=platform \
    image
FROM --platform=platform image
FROM --platform=platform repo/image:tag@digest AS label
FROM --platform=platform repo1.com/repo2/repo3/image:tag@digest AS label
FROM --platform=plat${VAR}form r${VAR}epo/im${VAR}age:t${VAR}ag@di${VAR}gest AS la${VAR}bel
FROM --platform=plat$VARform r$VARepo/im$VARage:t$VARag@di$VARgest AS la$VARbel

# here is an error
FROM image name

# RUN ...

RUN
RUN --mount
RUN --mount=asd${VAR}sdf
RUN --mount=asd${VAR}sdf --network=TYPE --security=sandbox
RUN --mount=asd${VAR}sdf --network=TYPE --security=sandbox echo foo bar 123
RUN echo foo bar 123
RUN --mount=type=ssh \
  ssh -q -T git@gitlab.com 2>&1 | tee /hello
RUN --mount=asd${VAR}sdf --network=TYPE --security=sandbox ["echo", "foo${VAR}bar", "123"]
RUN   [   "echo", "foo${VAR}bar", "123"     ]
RUN ["echo", \
    "foo${VAR}bar", \
    "123"]
RUN ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && apt-get --no-install-recommends install -y gcc
RUN apt update && \
    apt-get --no-install-recommends install -y gcc && \
    echo 123

RUN <<EOT bash
  set -ex
  apt-get update
  apt-get install -y vim

  echo 123
EOT

RUN <<EOT
  mkdir -p foo/bar
EOT

RUN <<"EOT"
  mkdir -p foo/bar
EOT

RUN <<-"EOT"
  mkdir -p foo/bar
EOT

# here are errors
RUN ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
RUN ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
RUN ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
RUN ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
RUN ["echo", "foo${VAR}bar",]
RUN ["echo", "foo${VAR}bar",           ]
RUN [echo
RUN ["echo", echo

# CMD ...

CMD
CMD echo foo bar 123
CMD \
  ssh -q -T git@gitlab.com 2>&1 | tee /hello
CMD ["echo", "foo${VAR}bar", "123"]
CMD   [   "echo", "foo${VAR}bar", "123"     ]
CMD ["echo", \
    "foo${VAR}bar", \
    "123"]
CMD ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]
CMD apt update && \
    apt-get --no-install-recommends install -y gcc && \
    echo 123

# here are errors
CMD ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
CMD ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
CMD ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
CMD ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
CMD ["echo", "foo${VAR}bar",]
CMD ["echo", "foo${VAR}bar",           ]
CMD [echo
CMD ["echo", echo

# LABEL ...

LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL "ver   sion"="1.0"
LABEL ver${VAR}sion="1.0.${VAR}"
LABEL $VAR=${VAR}
LABEL "$VAR foo ${VAR}"=${VAR}
LABEL foo=${VAR}
LABEL foo=bar
LABEL description="This text illustrates \
that label-values can span multiple lines."

LABEL multi.label1="value1" multi.label2="value2"                   other="value3"
LABEL multi.label1="value1" \
      multi.label2="value2"     \
      multi.label2="value2"\
      other="value3"

# here are errors
LABEL fo o=${VAR}
LABEL foo=bar baz
LABEL foo
LABEL f"oo
LABEL "foo

# MAINTAINER ...

MAINTAINER
MAINTAINER foo

# EXPOSE ...

EXPOSE
EXPOSE 10 20
EXPOSE 1${VAR}0 2$VAR0 \
    39 $VAR
EXPOSE 10/udp 20/tcp 50
EXPOSE 10/tcp

# here are errors
EXPOSE a
EXPOSE 10a
EXPOSE a10
EXPOSE 10/ 30
EXPOSE 20/
EXPOSE 20/foo

# ENV

ENV "com.example.vendor"="ACME Incorporated"
ENV com.example.label-with-value="foo"
ENV version="1.0"
ENV ver${VAR}sion="1.0.${VAR}"
ENV $VAR=${VAR}
ENV foo=${VAR}
ENV foo=bar
ENV description="This text illustrates \
that label-values can span multiple lines."

ENV multi.label1="value1" multi.label2="value2"                   other="value3"
ENV multi.label1="value1" \
      multi.label2="value2"     \
      multi.label2="value2"\
      other="value3"
ENV foo bar b${VAR}az qux $VAR
ENV foo$VAR $VAR
ENV "foo" $VAR
ENV "foo${VAR}" foo $VAR
ENV "${VAR}" foo $VAR
ENV foo \
    test \
    $VAR
ENV \
    foo \
    $VAR
ENV \
    foo \
    $VAR \
    foo \
    bar
ENV fo o=${VAR}
ENV foo
ENV \
foo
ENV f"oo

ENV MY_NAME="John Doe"
ENV MY_DOG=Rex\ The\ Dog
ENV MY_CAT=fluffy

ENV MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
    MY_CAT=fluffy

ENV MY_VAR my-value
ENV ONE TWO= THREE=world

# here are errors
ENV "ver   sion"="1.0"
ENV \
    "ver   sion"="1.0"
ENV "$VAR foo ${VAR}"=${VAR}
ENV foo=bar baz
ENV "foo
ENV "foo bar"

# ADD ...

ADD
ADD --mount
ADD --mount=asd${VAR}sdf
ADD --mount=asd${VAR}sdf --network=TYPE --security=sandbox
ADD --mount=asd${VAR}sdf --network=TYPE --security=sandbox echo foo "bar" 123
ADD echo "foo" bar 123
ADD --mount=type=ssh \
  $TEST $DEST
ADD --mount=asd${VAR}sdf --network=TYPE --security=sandbox ["echo", "foo${VAR}bar", "123"]
ADD   [   "echo", "foo${VAR}bar", "123"     ]
ADD ["echo", \
    "foo${VAR}bar", \
    "123"]
ADD ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]
ADD --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  "${VAR1} path" "  ${DEST}  "
ADD \
file\
file \
dest

ADD file1.txt file2.txt /usr/src/things/
ADD https://example.com/archive.zip /usr/src/things/
ADD git@github.com:user/repo.git /usr/src/things/

# here are errors
ADD ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
ADD ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
ADD ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
ADD ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
ADD ["echo", "foo${VAR}bar",]
ADD ["echo", "foo${VAR}bar",           ]
ADD [echo
ADD ["echo", echo

# COPY ...

COPY
COPY --mount
COPY --mount=asd${VAR}sdf
COPY --mount=asd${VAR}sdf --network=TYPE --security=sandbox
COPY --mount=asd${VAR}sdf --network=TYPE --security=sandbox echo foo "bar" 123
COPY echo "foo" bar 123
COPY --mount=type=ssh \
  $TEST $DEST
COPY --mount=asd${VAR}sdf --network=TYPE --security=sandbox ["echo", "foo${VAR}bar", "123"]
COPY   [   "echo", "foo${VAR}bar", "123"     ]
COPY ["echo", \
    "foo${VAR}bar", \
    "123"]
COPY ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]
COPY --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  "${VAR1} path" "  ${DEST}  "
COPY \
file\
file \
dest

COPY file1.txt file2.txt /usr/src/things/
COPY https://example.com/archive.zip /usr/src/things/
COPY git@github.com:user/repo.git /usr/src/things/

COPY <<EOF greeting.txt
hello world
EOF

COPY <<-EOT /script.sh
  echo "hello ${FOO}"
EOT

COPY <<-"EOT" /script.sh
  echo "hello ${FOO}"
EOT

# here are errors
COPY ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
COPY ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
COPY ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
COPY ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
COPY ["echo", "foo${VAR}bar",]
COPY ["echo", "foo${VAR}bar",           ]
COPY [echo
COPY ["echo", echo

# ENTRYPOINT ...

ENTRYPOINT
ENTRYPOINT echo foo bar 123
ENTRYPOINT \
  ssh -q -T git@gitlab.com 2>&1 | tee /hello
ENTRYPOINT ["echo", "foo${VAR}bar", "123"]
ENTRYPOINT   [   "echo", "foo${VAR}bar", "123"     ]
ENTRYPOINT ["echo", \
    "foo${VAR}bar", \
    "123"]
ENTRYPOINT ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]
ENTRYPOINT apt update && \
    apt-get --no-install-recommends install -y gcc && \
    echo 123

# here are errors
ENTRYPOINT ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
ENTRYPOINT ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
ENTRYPOINT ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
ENTRYPOINT ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
ENTRYPOINT ["echo", "foo${VAR}bar",]
ENTRYPOINT ["echo", "foo${VAR}bar",           ]
ENTRYPOINT [echo
ENTRYPOINT ["echo", echo

# VOLUME ...

VOLUME
VOLUME echo foo bar 123
VOLUME \
  ssh -q -T git@gitlab.com 2>&1 | tee /hello
VOLUME ["echo", "foo${VAR}bar", "123"]
VOLUME   [   "echo", "foo${VAR}bar", "123"     ]
VOLUME ["echo", \
    "foo${VAR}bar", \
    "123"]
VOLUME ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]
VOLUME apt update && \
    apt-get --no-install-recommends install -y gcc && \
    echo 123

# here are errors
VOLUME ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
VOLUME ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
VOLUME ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
VOLUME ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
VOLUME ["echo", "foo${VAR}bar",]
VOLUME ["echo", "foo${VAR}bar",           ]
VOLUME [echo
VOLUME ["echo", echo

# USER ...

USER
USER a
USER a:b
USER                  a:b
USER ${FOO}:${BLA}
USER foo
USER foo123
USER 123
USER foo:gid
USER foo11:gid44
USER foo:123
USER 123:123${VAR}12
USER $VAR:$VAR
USER foo${VAR}aaaaa:${VAR}baz
USER \
    foo

# here are errors
USER foo.134
USER ;;slkdjf
USER foo:%$#fsdf
USER foo:%$SDf
USER foo bar
USER foo:bar baz
USER :123
USER :foo

# WORKDIR

WORKDIR
WORKDIR a
WORKDIR         foo
WORKDIR $VAR
WORKDIR bar${VAR}123

# here is an error
WORKDIR foo bar

# ARG

ARG "com.example.vendor"="ACME Incorporated"
ARG com.example.label-with-value="foo"
ARG version="1.0"
ARG ver${VAR}sion="1.0.${VAR}"
ARG $VAR=${VAR}
ARG foo=${VAR}
ARG foo=bar
ARG description="This text illustrates \
that label-values can span multiple lines."

ARG multi.label1="value1" multi.label2="value2"                   other="value3"
ARG multi.label1="value1" \
      multi.label2="value2"     \
      multi.label2="value2"\
      other="value3"
ARG foo bar b${VAR}az qux $VAR
ARG foo$VAR $VAR
ARG foo="$VAR space here" bar baz $VAR
ARG "foo" $VAR
ARG "foo${VAR}" foo $VAR
ARG "${VAR}" foo $VAR
ARG foo \
    test \
    $VAR
ARG \
    foo \
    $VAR
ARG \
    foo \
    $VAR \
    foo \
    bar
ARG fo o=${VAR}
ARG foo
ARG \
foo
ARG f"oo

ARG MY_NAME="John Doe"
ARG MY_DOG=Rex\ The\ Dog
ARG MY_CAT=fluffy

ARG MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
    MY_CAT=fluffy

ARG MY_VAR my-value
ARG ONE TWO= THREE=world
ARG foo=bar baz

# STOPSIGNAL

STOPSIGNAL
STOPSIGNAL 123
STOPSIGNAL SIG
STOPSIGNAL SIGKILL
STOPSIGNAL $VAR
STOPSIGNAL SIG${VAR}

# here are errors
STOPSIGNAL -1
STOPSIGNAL #$%^^
STOPSIGNAL 1 foo
STOPSIGNAL SIGKILL 1

# HEALTHCHECK

HEALTHCHECK
HEALTHCHECK NONE
HEALTHCHECK \
    NONE
HEALTHCHECK --foo
HEALTHCHECK \
--foo
HEALTHCHECK --foo=bar --baz=qux
HEALTHCHECK --foo=bar \
    --baz=qux
HEALTHCHECK CMD echo 123
HEALTHCHECK --foo=bar CMD echo 123

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

# here are errors
HEALTHCHECK NONE foo
HEALTHCHECK --foo=bar --baz=qux foo
HEALTHCHECK --foo=bar --baz=qux NONE

# SHELL

SHELL
SHELL ["echo", "foo${VAR}bar", "123"]
SHELL \
    ["echo", "foo${VAR}bar", "123"]
SHELL   [   "echo", "foo${VAR}bar", "123"     ]
SHELL ["echo", \
    "foo${VAR}bar", \
    "123"]
SHELL ["echo" \
    ,"foo${VAR}bar" \
    ,"123"]

# here are errors
SHELL apt update && \
    apt-get --no-install-recommends install -y gcc && \
    echo 123
SHELL 1
SHELL foo
SHELL ["echo", "foo${VAR}bar", "123"] sfdsdfasdfasdf
SHELL ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
SHELL ["echo", "foo${VAR}bar", "123" sfdsdfasdfasdf
SHELL ["echo", "foo${VAR}bar", "123 sfdsdfasdfasdf
SHELL ["echo", "foo${VAR}bar",]
SHELL ["echo", "foo${VAR}bar",           ]
SHELL [echo
SHELL ["echo", echo

# random strings -> errors

foo
foo bar baz



