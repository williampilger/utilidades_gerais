<!DOCTYPE html>

<?php

    $employeeName = basename(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
    $jsonFile = "contacts/$employeeName.json";

    if(file_exists($jsonFile))
    {
        $employeeData = json_decode(file_get_contents($jsonFile), true);

        ?>
        <html>
            <head>
                <meta charset="utf-8">
                <title><?=htmlspecialchars($employeeData['name']) ?></title>
                <meta
                    property="og:title"
                    content="<?=$employeeData['name'] ?>"
                />
                <meta
                    property="og:description"
                    content="<?=$employeeData['position'] ?>"
                />
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" href="style.css">
            </head>
            <body>
                <div id="main">
                    <div class="profile-full">
                        <img class="profile-photo" src="<?=$employeeData['photo'] ?>" alt="Foto de <?=htmlspecialchars($employeeData['name'])?>">
                        <img class="corporation-photo" src="resources/logo.png" alt="Foto da corporação">
                    </div>
                    <div class="data">
                        <h1><?=htmlspecialchars($employeeData['name']) ?></h1>
                        <span><?=htmlspecialchars($employeeData['position']) ?></span>
                    </div>
                </div>
                <div id="sections">
                    <?php
                    foreach ($employeeData['sections'] as $section) {
                        ?>
                        <div class="sec">
                            <h2 class="title"><?=htmlspecialchars($section['title']) ?></h2>
                            <?php
                            foreach ($section['items'] as $item) {
                                ?>
                                <a class="item" href="<?=htmlspecialchars($item['url'])?>">
                                    <img class="item-icon" src="<?=htmlspecialchars($item['icon'])?>">
                                    <span class="item-text"><?=htmlspecialchars($item['name'])?></span>
                                </a>
                                
                                <?php
                            }
                            ?>
                        </div>
                        <?php
                    }
                    ?>
                </div>
            </body>
        </html>
        <?php
    }
    else
    {
        ?>
        <p>Contato não encontrado</p>
        <?php
    }
?>