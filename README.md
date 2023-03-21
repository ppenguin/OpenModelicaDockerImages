Dockerfiles for the OpenModelica version of the branch name.

## GUI Image

Added `qtwayland5` to support running natively under `Wayland`.

### Running

(Example OMEdit under `Wayland`)

```
docker run -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -e XDG_SESSION_TYPE=wayland \
           -e QT_QPA_PLATFORM=wayland \
           -e MODELICAPATH=$HOME/.openmodelica/libraries \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY  \
           -v $HOME:$HOME \
           -e HOME=$HOME \
           -w $HOME \
           --user=$(id -u):$(id -g) \
           --rm \
           openmodelica/openmodelica:v1.20.0-gui OMEdit
```