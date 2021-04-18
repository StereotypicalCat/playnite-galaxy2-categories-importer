function global:OnApplicationStarted()
{
}

function global:OnApplicationStopped()
{
}

function global:ImportCategories()
{
    # Temporarily fix since i dont know
    $catsObjs = New-Object System.Collections.Generic.List[Playnite.SDK.Models.Category]
    $cats = "Played","Played (BLACK)","Played (RED)","Played (Yellow)","Potential","Playing","Trash"



    # Import TAB delimited file
    $csvData = Import-Csv -Delimiter "`t" -Path G:\Projects\github-repos\playnite-galaxy2-categories-importer\gameDB.csv

    $PlayniteApi.Dialogs.ShowMessage("Loaded csv")

    foreach ($cat in $cats) {
        $temp = New-Object Playnite.SDK.Models.Category($cat)
        $PlayniteApi.Database.Categories.Add($temp)
        $catsObjs.Add($temp);
    }
    
    $PlayniteApi.Dialogs.ShowMessage("Created new category")

    $games = $PlayniteApi.Database.Games
    foreach ($game in $games) {
        $searchTerm = $game.Name
        $temp = $csvData | Where-Object {$_.title -match $searchTerm}
        if ($temp -ne $null){
            # Found something good :)
            if ($temp.tags -ne ""){
                foreach ($cat in $catsObjs) {
                    if ($cat.Name -like $temp.tags){
                        if ($game.CategoryIds -eq $null){
                            $game.CategoryIds = New-Object System.Collections.Generic.List[System.Guid]
                        }
                        $game.CategoryIds.Add($cat.Id)
                    }
                }
            }
        }
    }
    $PlayniteApi.Dialogs.ShowMessage($noOfEqualities)


    $PlayniteApi.Dialogs.ShowMessage("Search is done")
}

function global:GetMainMenuItems()
{
    param($menuArgs)

    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.Description = "Import GOG 2.0 Categories..."
    $menuItem.FunctionName = "ImportCategories"
    $menuItem.MenuSection = "@"
    return $menuItem
}