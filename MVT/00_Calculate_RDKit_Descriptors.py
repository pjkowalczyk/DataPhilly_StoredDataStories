import os
os.getcwd()

import pandas as pd
from rdkit import Chem, DataStructs
from rdkit.Chem import AllChem
from rdkit.Chem import Descriptors
from rdkit.ML.Descriptors import MoleculeDescriptors

df = pd.read_excel('data/biodegradability.xls', parse_dates = False)

df.info()

df.drop(columns=['Data Set', 'Appliation Domain (ID: In Domain, OD: Out of Domain)'], inplace = True)

df.rename(columns={'Experimental Labels': 'EndPt'}, inplace = True)

df.head(1)

names = [x[0] for x in Descriptors._descList]

calc = MoleculeDescriptors.MolecularDescriptorCalculator(names)

alles = pd.DataFrame()
for smiles in df['SMILES']:
    m = Chem.MolFromSmiles(smiles)
    alles = alles.append(pd.DataFrame([calc.CalcDescriptors(m)]))
alles.columns = names
    
qaz = pd.concat([df.reset_index(drop=True), alles.reset_index(drop=True)], axis=1)  
   
qaz.shape

qaz.dropna(inplace = True)

qaz.shape

qaz.sample(5)

qaz.drop(columns=['SMILES'], inplace = True)

qaz.to_csv('data/BioDeg.csv', index = False)

