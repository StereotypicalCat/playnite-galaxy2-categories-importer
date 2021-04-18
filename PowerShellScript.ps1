function global:OnApplicationStarted()
{
}

function global:OnApplicationStopped()
{
}

function global:ImportCategories()
{
    $games = $PlayniteApi.Database.Games

    $testcat = New-Object Playnite.SDK.Models.Category('test')
    $PlayniteApi.Database.Categories.Add($testcat)
    $PlayniteApi.Dialogs.ShowMessage("Created new category")

    foreach ($game in $games) {
        if ($game.Name -eq "20XX") {
            $PlayniteApi.Dialogs.ShowMessage($game.Name)

            if ($game.CategoryIds -eq $null){
                $game.CategoryIds = New-Object System.Collections.Generic.List[System.Guid]
            }
            $game.CategoryIds.Add($testcat.Id)
            
        }
    }

    $PlayniteApi.Dialogs.ShowMessage("Search is done")
}

function global:GetCsv()
{
    # Import TAB delimited file
    $data = Import-Csv -Delimiter "`t" -Path G:\Projects\github-repos\playnite-galaxy2-categories-importer\gameDB.csv
    $searchTerm = "20XX"
    $test = $data | Where-Object {$_.title -match $searchTerm}
    $PlayniteApi.Dialogs.ShowMessage($test.title)
}


function global:GetMainMenuItems()
{
    param($menuArgs)

    $menuItem = New-Object Playnite.SDK.Plugins.ScriptMainMenuItem
    $menuItem.Description = "Import GOG 2.0 Categories..."
    #$menuItem.FunctionName = "ImprotCategories"
    $menuItem.FunctionName = "GetCsv"
    $menuItem.MenuSection = "@"
    return $menuItem
}