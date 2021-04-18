function global:OnApplicationStarted()
{
}

function global:OnApplicationStopped()
{
}

function global:ImportCategories()
{
    # Import TAB delimited file
    $csvData = Import-Csv -Delimiter "`t" -Path G:\Projects\github-repos\playnite-galaxy2-categories-importer\gameDB.csv

    $PlayniteApi.Dialogs.ShowMessage("Loaded csv")
    
    $testcat = New-Object Playnite.SDK.Models.Category('test')
    $PlayniteApi.Database.Categories.Add($testcat)
    $PlayniteApi.Dialogs.ShowMessage("Created new category")

    $games = $PlayniteApi.Database.Games
    foreach ($game in $games) {
        $searchTerm = $game.Name
        $temp = $csvData | Where-Object {$_.title -match $searchTerm}
        if ($temp -ne $null){
            # Found something good :)
            if ($temp.tags -ne ""){
                $PlayniteApi.Dialogs.ShowMessage($temp.title)
                $PlayniteApi.Dialogs.ShowMessage($temp.tags)
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