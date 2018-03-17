import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main = Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


-- MODEL


type alias Model = { counter : Int }

initialModel : Model
initialModel = Model 0

init: (Model, Cmd Msg)
init = (initialModel, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Get ] [ text "Get" ]
    , button [ onClick Set ] [ text "Set" ]
    , h2 [] [text (toString model.counter)]
    ]


--UPDATE


type Msg = Get
          |Set
          |GetCount (Result Http.Error Int)
          |SetCount (Result Hrrp.Error Int)

update : Msg -> Model -> Model
update msg model =
  case msg of
    Get ->
      (model, getCount model.counter)
    Set ->
      (model, setCount model.counter)
    GetCount result ->
      case result of
        Ok val ->
          ({model | counter = val}, Cmd.none)
        Err _ ->
          (model, Cmd.none)
    SetCount result ->
      case result of
        Ok val ->
          ({model | counter = val}, Cmd.none)
        Err _ ->
          (model, Cmd.none)

-- HTTP

getCount : Cmd Msg
getCount =
  let
    url = "http://localhost:8080/Server_elm_exercise/api/counter"
    request = Htttp.get url countDecoder
  in
      Http.send GetCount request


setCount : Cmd Msg
setCount  =
  let
    url = "http://localhost:8080/Server_elm_exercise/api/counter/1"
    request = Htttp.post url Http.emptyBody int
  in
      Http.send SetCount request


-- DECODER


countDecoder : Decoder Int
countDecoder = at ["counter"] int
