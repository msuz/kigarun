# kigarun
simple web app with low-cost AWS resources

## architecture

```mermaid
flowchart LR
  node_1["Frontend"]
  node_2["API"]
  node_3[("DB")]
  node_1 --> node_2
  node_2 --> node_3
```

## setup

```
% xcode-select --install       
```

```
% cd ~/git/
% git clone git@github.com:msuz/kigarun.git
```

* https://code.visualstudio.com/download

* https://marketplace.visualstudio.com/items?itemName=corschenzi.mermaid-graphical-editor

```
% pip install bot3
```

```
% cd kigarun/infra && terraform init
```

## deploy

```
% terraform apply
```
