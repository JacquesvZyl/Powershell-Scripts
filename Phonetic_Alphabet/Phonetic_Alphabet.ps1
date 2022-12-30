

function Get-Phonetic {
    param(
        [parameter(Mandatory = $true)]
        [string]$word
    )

    $Alphabet = @{
        a = 'Alpha'
        b = 'Bravo'
        c = 'Charlie' 
        d = 'Delta' 
        e = 'Echo' 
        f = 'Foxtrot' 
        g = 'Golf' 
        h = 'Hotel' 
        i = 'India' 
        j = 'Juliett' 
        k = 'Kilo' 
        l = 'Lima' 
        m = 'Mike' 
        n = 'November' 
        o = 'Oscar' 
        p = 'Papa' 
        q = 'Quebec' 
        r = 'Romeo' 
        s = 'Sierra' 
        t = 'Tango' 
        u = 'Uniform' 
        v = 'Victor' 
        w = 'Whiskey' 
        x = 'X-ray' 
        y = 'Yankee' 
        z = 'Zulu'
    }

  
    foreach ($letter in $word.ToCharArray()) {

        
        $phonetic = $Alphabet[$letter.ToString()]

        if ($letter -eq " ") {
            Write-Host ""
            Write-Host 'SPACE' -ForegroundColor Green
            Write-Host ""
        }
        elseif ($phonetic) {
            Write-Host "$letter - $phonetic"
        }
    }
}



$word = Read-Host "Enter word to transform into NATO phonetics"


Get-Phonetic -word $word