import time
import pandas as pd
from country_converter import CountryConverter

disclaimer = """
Disclaimer: I do not recomend running this code. Line 26 in particular took over
an hour to finish converting all the numerics into strings. This code is just
here to easily go over what I did to convert my data into a usable format in
Stata.
"""

print(disclaimer)
input = input("That being said, do you still want to run it for some reason? (Y/N) ")
if input.lower() == 'y':  
    # Load dta files into dataframes for manipulation and clean up
    path1 = "C:/Users/Brady/Dropbox/Econometrics/Conflict Frequency and Cultural Values/Datasets/conflict.dta"
    df1 = pd.read_stata(path1)
    path2 = "C:/Users/Brady/Dropbox/Econometrics/Conflict Frequency and Cultural Values/Datasets/survey_working.dta"
    df2 = pd.read_stata(path2, convert_categoricals=False)


    # Convert ISO 3 codes into English country names
    df2 = df2[df2.B_COUNTRY != 909]
    print("Here we go!")
    start_time = time.time()
    df2['Country'] = df2.B_COUNTRY.apply(lambda code: CountryConverter().convert(code, to='name_short'))
    end_time = time.time()
    print(end_time - start_time)

    # Clean up strings.
    df1['Country'] = df1.side_a.str.replace('Government of ', '')
    df1['Country'] = df1.Country.str.replace(' of America', '')

    # Convert string dates to actual and compute conflict duration.
    df1.start_date = pd.to_datetime(df1.start_date)
    df1.ep_end_date = pd.to_datetime(df1.ep_end_date)
    df1['Duration'] = (df1.ep_end_date - df1.start_date).dt.days
    conflict_duration = df1.groupby(['Country', 'conflict_id'])['Duration'].max().reset_index()
    total_conflict_duration = conflict_duration.groupby('Country')['Duration'].sum().reset_index()

    # Merge and save the new dataset.
    merged = pd.merge(df2, total_conflict_duration, on='Country', how='left', indicator=True)
    merged.to_stata("Datasets/sur_con_m_test.dta")
else:
    exit()