module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit, onClick, onInput)
import Http
import Json.Encode as Encode
import Json.Decode as Json


type alias Model =
    { email : String
    , message : String
    }


initialModel : Model
initialModel =
    { email = ""
    , message = ""
    }


type Msg
    = InputEmail String
    | InputMessage String
    | Submit
    | SubmitResponse (Result Http.Error String)


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> Sub.none
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputEmail e ->
            ( { model | email = String.toLower e }, Cmd.none )

        InputMessage m ->
            ( { model | message = m }, Cmd.none )

        Submit ->
            ( model, submit model )

        SubmitResponse _ ->
            ( model, Cmd.none )


submit : Model -> Cmd Msg
submit model =
    let
        url =
            "http://localhost:3000/api/contact"

        payload =
            Encode.object
                [ ( "email", Encode.string model.email )
                , ( "message", Encode.string model.message )
                ]

        request : Http.Request String
        request =
            Http.post url (Http.jsonBody payload) Json.string
    in
        request |> Http.send SubmitResponse


view : Model -> Html Msg
view model =
    Html.form
        []
        [ header
        , body model
        , footer
        , div [] [ model |> toString |> text ]
        ]


header =
    div []
        [ h1 [] [ text "Contact us" ] ]


body model =
    div []
        [ div []
            [ input
                [ placeholder "your email"
                , type_ "email"
                , onInput InputEmail
                , value model.email
                ]
                []
            ]
        , div []
            [ textarea
                [ placeholder "your message"
                , rows 7
                , onInput InputMessage
                ]
                []
            ]
        ]


footer =
    div []
        [ button
            [ type_ "button"
            , onClick Submit
            ]
            [ text "Submit" ]
        ]
