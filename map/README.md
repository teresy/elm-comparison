https://github.com/dillonkearns/elm-graphql/pull/75/files
https://github.com/dillonkearns/elm-graphql/pull/75/files

This patch is needed so that elm-lint can find the issue:

```
diff --git a/map/graphql/generator/src/Graphql/Generator/Imports.elm b/map/graphql/generator/src/Graphql/Generator/Imports.elm
index 6348f4e..ec4ac0b 100644
--- a/map/graphql/generator/src/Graphql/Generator/Imports.elm
+++ b/map/graphql/generator/src/Graphql/Generator/Imports.elm
@@ -19,10 +19,8 @@ importsString : List String -> List String -> List Type.Field -> String
 importsString apiSubmodule importingFrom typeRefs =
     typeRefs
         |> allRefs
-        |> importsWithoutSelf apiSubmodule importingFrom
         |> List.map toModuleName
         |> List.map toImportString
-        |> String.join "\n"
 
 
 importsWithoutSelf : List String -> List String -> List TypeReference -> List (List String)
```
