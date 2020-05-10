FROM amazonlinux:2

# 各環境変数を設定
ENV USER ec2-user
ENV HOME /home/${USER}

RUN echo "now building..."

# Install General Tools
RUN yum update -y \
        && yum install -y git wget tar make \
            gcc openssl-devel bzip2-devel libffi-devel

# Install Python 3.8 && Poetry
RUN cd /opt \
        && wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz \
        && tar xzf Python-3.8.2.tgz \
        && cd Python-3.8.2 \
        && ./configure --enable-optimizations \
        && make altinstall \
        && rm -f /opt/Python-3.8.2.tgz \
        && python3.8 --version \
        && pip3.8 --version

# 手元の公開鍵をコピー
COPY authorized_keys /tmp/id_rsa.pub

# Install SSH Server && Create and setting ec2-user.
RUN yum -y install \
        sudo \
        openssh-server \
        openssh-clients \
        which && \
    # キャッシュを削除
    yum clean all && \
    # SSH サーバを起動
    systemctl enable sshd.service && \
    # パスワード認証による SSH アクセスを禁止
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    # ec2-user を追加
    useradd ${USER} && \
    # ec2-user で sudo コマンドを使用できるようにする
    echo "ec2-user ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    # ec2-user のホームディレクトリ下に公開鍵を配置
    sudo -u ${USER} mkdir -p ${HOME}/.ssh && \
    mv /tmp/id_rsa.pub ${HOME}/.ssh/ && \
    chmod -R go-rwx ${HOME}/.ssh && \
    # 公開鍵を登録
    cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys

# USER ${USER}
WORKDIR ${HOME}
RUN sudo -u ${USER} curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3.8 \
        && echo 'alias poetry="python3.8 $HOME/.poetry/bin/poetry"' >> /home/ec2-user/.bashrc

RUN echo "finished."
