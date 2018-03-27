module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode as Json
import Json.Encode as Encode


type alias Model =
    { email : String
    , message : String
    , status : SubmissionStatus
    }


type SubmissionStatus
    = NotSubmitted
    | InProcess
    | Succeeded
    | Failed


initialModel : Model
initialModel =
    { email = ""
    , message = ""
    , status = NotSubmitted
    }


type Msg
    = InputEmail String
    | InputMessage String
    | Submit
    | SubmitResponse (Result Http.Error ())


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
            ( { model | email = e }, Cmd.none )

        InputMessage m ->
            ( { model | message = m }, Cmd.none )

        Submit ->
            ( { model | status = InProcess }, submit model )

        SubmitResponse (Ok ()) ->
            ( { model
                | status = Succeeded
                , email = ""
                , message = ""
              }
            , Cmd.none
            )

        SubmitResponse (Err _) ->
            ( { model | status = Failed }, Cmd.none )


submit : Model -> Cmd Msg
submit model =
    let
        url =
            "http://localhost:3000/api/contact"

        json =
            Encode.object
                [ ( "email", Encode.string model.email )
                , ( "message", Encode.string model.message )
                ]

        decoder =
            Json.string |> Json.map (always ())

        request =
            Http.post url (Http.jsonBody json) decoder
    in
        request |> Http.send SubmitResponse


view : Model -> Html Msg
view model =
    Html.form
        [ onSubmit Submit ]
        [ header model
        , body model
        , footer model
        , div [] [ model |> toString |> text ]
        ]


header model =
    div []
        [ h1 [] [ text "Contact us" ]
        , renderStatus model.status
        ]


renderStatus status =
    case status of
        NotSubmitted ->
            div [] []

        InProcess ->
            div [] [ text "Your request is being sent" ]

        Succeeded ->
            div [] [ text "Your request has been received" ]

        Failed ->
            div [ class "alert alert-danger" ]
                [ text "Ops! There was an error, please try again" ]


body model =
    div []
        [ div []
            [ input
                [ placeholder "your email"
                , type_ "email"
                , onInput InputEmail
                , value model.email
                , required True
                ]
                []
            ]
        , div []
            [ textarea
                [ placeholder "your message"
                , rows 7
                , onInput InputMessage
                , value model.message
                , required True
                ]
                []
            ]
        ]


footer model =
    div []
        [ button
            [ type_ "submit"
            , disabled (model.status == InProcess)
            ]
            [ text "Submit" ]
        , button
            [ type_ "button" ]
            [ text "Cancel" ]
        ]
