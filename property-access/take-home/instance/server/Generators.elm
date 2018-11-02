generateSignupPage : Response -> Request -> Model -> Task String ()
generateSignupPage res req model =
    let
        applicationId =
            getFormField "applicationId" req.form
                |> Maybe.withDefault "-1"
                |> String.toInt
                |> Result.withDefault -1

        email =
            getFormField "email" req.form
                |> Maybe.withDefault ""
                |> String.trim
                |> String.toLower

        role =
            getFormField "role" req.form
                |> Maybe.withDefault ""
                |> String.trim

        searchUser =
            { applicationId = applicationId
            , email = email
            }

        getToken =
            randomUrl False ""

        getTest : String -> Maybe Shared.Test.TestEntry
        getTest role =
            testEntryByName role model.testConfig
                |> List.head

        jobs : Application -> String
        jobs application =
            List.map (\job -> job.name) application.jobs
                |> String.join ","

        checkValidity : (Candidate, Application) -> Task String (Candidate, Application)
        checkValidity union =
            if isValidGreenhouseCandidate union email applicationId then
                Task.succeed union
            else
                Task.fail "invalid email"

        tryInserting token candidate application =
            let
                jobTitle =
                    jobs application

                userWithToken =
                    { name = candidate.firstName ++ " " ++ candidate.lastName
                    , email = email
                    , token = token
                    , applicationId = application.id
                    , candidateId = candidate.id
                    , role = role
                    , jobTitle = jobTitle
                    , startTime = Nothing
                    , endTime = Nothing
                    , submissionLocation = Nothing
                    , test = getTest role
                    }

                url =
                    tokenAsUrl model.baseUrl token
            in
                User.insertIntoDatabase userWithToken model.database
                    |> andThen
                        (\_ ->
                            Task.succeed (successfulSignupView url userWithToken)
                        )
    in
        User.getUsers searchUser model.database
            |> andThen
                (\userList ->
                    case userList of
                        [] ->
                            getCandidateByApplication model.authSecret applicationId
                                |> andThen checkValidity
                                |> andThen (\union ->
                                    getToken
                                        |> andThen (\token -> Task.succeed (union, token))
                                    )
                                |> andThen (\((candidate, application), token) ->
                                    tryInserting token candidate application
                                    )
                                |> Task.mapError (\a ->
                                    let
                                        _ = Debug.log "a" a
                                    in
                                        "no such user")

                        existingUser :: [] ->
                            Task.succeed (alreadySignupView (tokenAsUrl model.baseUrl existingUser.token) existingUser)

                        _ ->
                            Task.fail "multiple users found with that name and email address"
                )
            |> andThen (\node -> writeNode node res)
