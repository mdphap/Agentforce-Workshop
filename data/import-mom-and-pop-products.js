
import {exec} from 'child_process';

import { promises as fs } from 'fs';

const exportStandardPriceBookCommand = 'sf data query --query "SELECT Id FROM PriceBook2 WHERE IsStandard = TRUE" --result-format json --output-file data/tmp.json';

// export standard pricebook
exec(exportStandardPriceBookCommand, (error, stdout, stderr) => {

    if (error) {
        console.error(`Execution error: ${error.message}`);
        return;
    }

    console.log('Query Result:', stdout);
});

// read standard pricebook id
try {

    let standardPriceBook = JSON.parse(await fs.readFile('data/tmp.json', 'utf8'));

    let priceBookEntries = JSON.parse(await fs.readFile('data/PricebookEntry.json', 'utf8'));

    for (let record of priceBookEntries.records) {
        record.Pricebook2Id == '@Pricebook2Ref1' && (record.Pricebook2Id = standardPriceBook.records[0].Id);
    }

    fs.writeFile("data/PricebookEntryHydrated.json", JSON.stringify(priceBookEntries));
    
} catch (err) {
    console.error('Error reading file:', err);
}

const importProductsCommand = 'sf data import tree --plan "data/plan.json"';

exec(importProductsCommand, (error, stdout, stderr) => {

    if (error) {
        console.error(`Execution error: ${error.message}`);
        return;
    }

    console.log('Query Result:', stdout);
});
