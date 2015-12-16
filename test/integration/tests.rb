#Pre_req: ################################################################################################################################################
# 1) Required parameters in a geocoding request: (address OR components) AND Key.  
#
# 2) Address is formed by: country roads, State Highways, U.S. Highways, U.S. Interstates.
#
# 3) Address components may include: floor, establishment, point_of_interest, parking, post_box, postal_town, room, street_number and bus_station.
#
# 4) Component is formed by: route, locality, administrative_area, postal_code and country.
#
# 5) Optional parameters in a geocoding request:  bounds, language, region, components.   
###########################################################################################################################################################

require 'airborne'
require File.expand_path("../../test_helper", __FILE__)

#Base URL that will be invoqued in test cases.
base_url='https://maps.googleapis.com/maps/api/geocode/json?'

#Valid key to receive response from server.
key_part='&key=AIzaSyBSArrqAuq-06jGoXB6e605VOXIrYu2wDg'

describe 'BOXEVER API Test Cases' do

 describe 'Test Cases to validate only KEY parameter' do #Starting KEY parameter
  it 'should validate request when using only valid Key' do      
    get "#{base_url + key_part}" 
	
	zero_results
  end
  
  it 'should validate REQUEST_DENIED with invalid Key' do 
    invalid_key='&key=test'  
    get "#{base_url + invalid_key}" 
	
	expect_json(status: "REQUEST_DENIED")
  end
  
  it 'should validate zero result with empty Key' do 
    empty_key='&key='  
    get "#{base_url + empty_key}" 
	
	zero_results
  end  
 end #Ending KEY parameter
 
 describe 'Test Cases to validate ADDRESS and /or KEY parameters' do  #Starting ADDRESS parameter
  it 'should validate valid address' do
    valid_address='address=Winnetka'
	get "#{base_url + valid_address + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Winnetka", short_name: "Winnetka")    
    expect_json('results.0', formatted_address: "Winnetka, IL, USA")	
	expect_json('results.0.address_components.0', types: ["locality", "political"])
	ok
  end
  
  it 'should validate invalid address with valid Key' do
    invalid_address='address=$$$'
	get "#{base_url + invalid_address + key_part}"
	
	zero_results
  end
  
  it 'should validate empty address with valid Key' do
    invalid_address='address='
	get "#{base_url + invalid_address + key_part}"
	
	zero_results
  end
  
  it 'should validate two valid addresses' do
    valid_address='address=Winnetka|Chicago'
	get "#{base_url + valid_address + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "METRA - Winnetka (Elm Street) Station", short_name: "METRA - Winnetka (Elm Street) Station")
    expect_json('results.0.address_components.6', long_name: "Illinois", short_name: "IL")
    
    expect_json('results.0', formatted_address: "METRA - Winnetka (Elm Street) Station, 754 Elm St, Winnetka, IL 60093, USA")	
	expect_json('results.0.address_components.0', types: ["point_of_interest", "establishment"])
	ok
  end
  
  it 'should validate two addresses: first one valid address and second one invalid' do
    valid_address='address=Winnetka|$$$'
	get "#{base_url + valid_address + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Winnetka", short_name: "Winnetka")    
    expect_json('results.0', formatted_address: "Winnetka, IL, USA")	
	expect_json('results.0.address_components.0', types: ["locality", "political"])
	ok
  end
  
  it 'should validate two addresses: first one invalid address and second one valid' do
    valid_address='address=$$$|Winnetka'
	get "#{base_url + valid_address + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Winnetka", short_name: "Winnetka")    
    expect_json('results.0', formatted_address: "Winnetka, IL, USA")	
	expect_json('results.0.address_components.0', types: ["locality", "political"])
	ok
  end
  
  it 'should validate valid address when using valid County Roads' do
    valid_address_county_road='address=Co Road 82'
	get "#{base_url + valid_address_county_road + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "County Road 82", short_name: "Co Rd 82") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "Co Rd 82, Colorado, USA")	
	expect_json('results.0.address_components.0', types: ["route"])
	ok
  end
  
  it 'should validate valid address when using empty County Roads' do
    invalid_address_county_road='address=Co Road '
	get "#{base_url + invalid_address_county_road + key_part }"

    expect_json('results.0.address_components.0', long_name: "Co Road East", short_name: "County Rd E") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "County Rd E, Wisconsin, USA")	
	expect_json('results.0.address_components.0', types: ["route"])
	ok	
  end  
  
  it 'should validate valid address when using valid State Highways' do
    valid_address_state_highway='address=California 82'
	get "#{base_url + valid_address_state_highway + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Highway 82", short_name: "CA-82") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "CA-82, California, USA")	
	expect_json('results.0', types: ["route"])
	ok
  end
  
  it 'should validate valid address when using valid State Highways without number' do
    valid_address_state_highway='address=California '
	get "#{base_url + valid_address_state_highway + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "California", short_name: "CA") 
	expect_json('results.0.address_components.0', types: ["administrative_area_level_1", "political"])	
    expect_json('results.0', formatted_address: "California, USA")	
	expect_json('results.0', types: ["administrative_area_level_1", "political"])
	ok
  end
  
  it 'should validate valid address when using valid U.S. Highways with points' do
    valid_address_us_highway='address=U.S. 101'
	get "#{base_url + valid_address_us_highway + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "U.S. 101", short_name: "US-101") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "US-101, United States")	
	expect_json('results.0', types: ["route"])
	ok
  end
  
  it 'should validate valid address when using valid U.S. Highways without points' do
    valid_address_us_highway='address=US 101'
	get "#{base_url + valid_address_us_highway + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "U.S. 101", short_name: "US-101") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "US-101, United States")	
	expect_json('results.0', types: ["route"])
	ok
  end
  
  it 'should validate valid address when using valid U.S. Highways without points and spaces' do
    valid_address_us_highway='address=US101'
	get "#{base_url + valid_address_us_highway + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "U.S. 101", short_name: "US-101") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "US-101, United States")	
	expect_json('results.0', types: ["route"])
	ok
  end
  
  it 'should validate valid address when using valid U.S. Highways without number' do
    valid_address_us_highway='address=US'
	get "#{base_url + valid_address_us_highway + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "United States", short_name: "US") 
	expect_json('results.0.address_components.0', types: ["country", "political"])	
    expect_json('results.0', formatted_address: "United States")	
	expect_json('results.0', types: ["country", "political"])
	ok
  end  
  
  it 'should validate valid address when using valid U.S. Interstates' do
    valid_address_us_interstate='address=Interstate 280'
	get "#{base_url + valid_address_us_interstate + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Interstate 280", short_name: "I-280") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "I-280, California, USA")	
	expect_json('results.0', types: ["route"])
	ok
  end
  
  it 'should validate valid address when using valid U.S. Interstates without number' do
    valid_address_us_interstate='address=Interstate '
	get "#{base_url + valid_address_us_interstate + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Interstate", short_name: "Interstate") 
	expect_json('results.0.address_components.0', types: ["route"])	
    expect_json('results.0', formatted_address: "Interstate, Jay, VT 05859, USA")	
	expect_json('results.0', types: ["route"])
	ok
  end  
  
  it 'should validate response when using valid address and valid place' do
    address_place='address=1600+Amphitheatre+Parkway,+Mountain+View,+CA'  
    get "#{base_url + address_place + key_part}"	
    
	expect_json('results.0.address_components.0', long_name: "1600", short_name: "1600") 
	expect_json('results.0.address_components.0', types: ["street_number"])	
    expect_json('results.0', formatted_address: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA")	
	expect_json('results.0', types: ["street_address"])
	ok
  end
 end #Ending ADDRESS parameter
 
 describe 'Test Cases to validate COMPONENTS and /or KEY parameters' do #Starting COMPONENTS parameter
  it 'should validate response with valid ROUTE without Key' do
    valid_component='components=route:Annegatan'
	get "#{base_url + valid_component }"
	
	expect_json('results.0.address_components.0', long_name: "Annegatan", short_name: "Annegatan")    
    expect_json('results.0', formatted_address: "Annegatan, 00101 Helsingfors, Finland")	
	expect_json('results.0', types: ["route"])
	ok		
  end
  
  it 'should validate response with valid ROUTE with valid Key' do
    valid_route='components=route:Annegatan'
	get "#{base_url + valid_route + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Annegatan", short_name: "Annegatan")    
    expect_json('results.0', formatted_address: "Annegatan, 00101 Helsingfors, Finland")	
	expect_json('results.0', types: ["route"])
	ok		
  end
  
  it 'should validate response with invalid ROUTE with valid Key' do
    invalid_route='components=route:$$$'
	get "#{base_url + invalid_route + key_part}"
	
	zero_results		
  end
  
  it 'should validate response with two ROUTEs: first one valid and second one invalid and with valid Key' do
    two_routes='components=route:Annegatan|$$$'
	get "#{base_url + two_routes + key_part }"
	
	expect_json('results.0.address_components.0', long_name: "Annegatan", short_name: "Annegatan")    
    expect_json('results.0', formatted_address: "Annegatan, 00101 Helsingfors, Finland")	
	expect_json('results.0', types: ["route"])
	ok		
  end
  
  it 'should validate response with two ROUTEs: first one invalid and second one valid and with valid Key' do
    two_routes='components=route:$$$|Annegatan'
	get "#{base_url + two_routes + key_part }"
	
	zero_results			
  end  
  
  it 'should validate response with valid LOCALITY with valid Key' do
    valid_locality='components=locality:Brooklyn'
	get "#{base_url + valid_locality + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "Brooklyn", short_name: "Brooklyn")    
    expect_json('results.0', formatted_address: "Brooklyn, NY, USA")	
	expect_json('results.0', types: ["sublocality_level_1", "sublocality", "political"])
	ok	
  end  
  
  it 'should validate response with invalid LOCALITY with valid Key' do
    invalid_locality='components=locality:$$$'
	get "#{base_url + invalid_locality + key_part}"
	
	zero_results	
  end
  
  it 'should validate response with two LOCALITies: first one valid and second one invalid and with valid Key' do
    two_localities='components=locality:Brooklyn|$$$'
	get "#{base_url + two_localities + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "Brooklyn", short_name: "Brooklyn")    
    expect_json('results.0', formatted_address: "Brooklyn, NY, USA")	
	expect_json('results.0', types: ["sublocality_level_1", "sublocality", "political"])
	ok	
  end
  
  it 'should validate response with two LOCALITies: first one invalid and second one valid and with valid Key' do
    two_localities='components=locality:$$$|Brooklyn'
	get "#{base_url + two_localities + key_part}"
	
	zero_results	
  end
  
  it 'should validate response with valid ADMINISTRATIVE AREA with valid Key' do
    valid_administrative_area='components=administrative_area:TX'
	get "#{base_url + valid_administrative_area + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "Texas", short_name: "TX")    
    expect_json('results.0', formatted_address: "Texas, USA")	
	expect_json('results.0.address_components.0', types: ["administrative_area_level_1", "political"])
	ok	
  end
  
  it 'should validate response with invalid ADMINISTRATIVE AREA with valid Key' do
    invalid_administrative_area='components=administrative_area:$$$'
	get "#{base_url + invalid_administrative_area + key_part}"
	
	zero_results		
  end
  
  it 'should validate response with valid two ADMINISTRATIVE AREAs: first one valid and second one invalid and with valid Key' do
    two_administrative_area='components=administrative_area:TX|$$$'
	get "#{base_url + two_administrative_area + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "Texas", short_name: "TX")    
    expect_json('results.0', formatted_address: "Texas, USA")	
	expect_json('results.0.address_components.0', types: ["administrative_area_level_1", "political"])
	ok	
  end
  
  it 'should validate response with valid two ADMINISTRATIVE AREAs: first one invalid and second one valid and with valid Key' do
    two_administrative_area='components=administrative_area:$$$|TX'
	get "#{base_url + two_administrative_area + key_part}"
	
	zero_results	
  end
  
  it 'should validate response with valid POSTAL CODE with valid Key' do
    valid_postal_code='components=postal_code:00100'
	get "#{base_url + valid_postal_code + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "00100", short_name: "00100")    
    expect_json('results.0', formatted_address: "00100 Helsinki, Finland")	
	expect_json('results.0.address_components.0', types: ["postal_code"])
	ok	
  end
  
  it 'should validate response with invalid POSTAL CODE with valid Key' do
    invalid_postal_code='components=postal_code:$$$'
	get "#{base_url + invalid_postal_code + key_part}"
	
	zero_results	
  end
  
  it 'should validate response with two POSTAL CODEs: first one valid and second one invalid and with valid Key' do
    two_postal_code='components=postal_code:00100|$$$'
	get "#{base_url + two_postal_code + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "00100", short_name: "00100")    
    expect_json('results.0', formatted_address: "00100 Helsinki, Finland")	
	expect_json('results.0.address_components.0', types: ["postal_code"])
	ok	
  end
  
  it 'should validate response with two POSTAL CODEs: first one invalid and second one valid and with valid Key' do
    two_postal_code='components=postal_code:$$$|00100'
	get "#{base_url + two_postal_code + key_part}"
	
	zero_results	
  end
  
  it 'should validate response with valid COUNTRY with valid Key' do
    valid_country='components=country:ES'
	get "#{base_url + valid_country + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "Spain", short_name: "ES")    
    expect_json('results.0', formatted_address: "Spain")	
	expect_json('results.0.address_components.0', types: ["country", "political"])
	ok
  end
  
  it 'should validate response with invalid COUNTRY with valid Key' do
    invalid_country='components=country:$$$'
	get "#{base_url + invalid_country + key_part}"
	
	zero_results
  end
  
  it 'should validate response with two COUNTRYs: first one valid and second one invalid and with valid Key' do
    two_countries='components=country:ES|$$$'
	get "#{base_url + two_countries + key_part}"
	
	expect_json('results.0.address_components.0', long_name: "Spain", short_name: "ES")    
    expect_json('results.0', formatted_address: "Spain")	
	expect_json('results.0.address_components.0', types: ["country", "political"])
	ok
  end
  
  it 'should validate response with two COUNTRYs: first one invalid and second one valid and with valid Key' do
    two_components='components=country:$$$|ES'
	get "#{base_url + two_components + key_part}"
	
	zero_results
  end  
 end #Ending COMPONENTS parameter
 
 describe 'Test Cases to validate OPTIONAL parameters' do #Starting OPTIONAL parameters 
  it 'should validate response when using valid address and valid bounds' do
    address_with_bounds='address=Winnetka&bounds=34.172684,-118.604794|34.236144,-118.500938'
	get "#{base_url + address_with_bounds + key_part }"   
	
	expect_json('results.0.address_components.0', long_name: "Winnetka", short_name: "Winnetka")    
    expect_json('results.0', formatted_address: "Winnetka, Los Angeles, CA, USA")	
	expect_json('results.0.address_components.0', types: ["neighborhood", "political"])
	
    latitude(34)   
	longitude(-118)
	expect_json('results.0', types: ["neighborhood", "political"])
	ok
  end
  
  #MORE TEST CASES MIGHT BE ADDED HERE COMBINING (county_road, state_highway, us_highway and us_interstate) with BOUNDS and with other optional parameters
  #that are: language, region and components !!! Some possibilites are possible here !!!   
  
  it 'should validate response when using valid components and valid bounds' do
    components_with_bounds='components=route:Annegatan&bounds=34.172684,-118.604794|34.236144,-118.500938'
	get "#{base_url + components_with_bounds + key_part }"   
	
	expect_json('results.0.address_components.0', long_name: "Anne Court", short_name: "Anne Ct")    
    expect_json('results.0', formatted_address: "Anne Ct, Thousand Oaks, CA 91320, USA")	
	expect_json('results.0.address_components.0', types: ["route"])
    
	latitude(34)
	longitude(-118)
	expect_json('results.0', types: ["route"])
	ok
  end
  
  #MORE TEST CASES MIGHT BE ADDED HERE COMBINING (locality, admistrative_area, postal_code and country)  with BOUNDS and with other optional parameters
  #that are: language, region and components !!! Some possibilites are possible here !!!   
  
 end #Ending OPTIONAL parameters
end
