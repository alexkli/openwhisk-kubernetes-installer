FROM dtzar/helm-kubectl

RUN git clone https://github.com/apache/incubator-openwhisk-deploy-kube.git openwhisk-deploy-kube

RUN helm init --client-only

COPY run.sh .
COPY values.yaml .

CMD ./run.sh