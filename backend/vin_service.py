

import requests

def get_vehicle_details(vin: str) -> dict:
    """
    Fetch vehicle details using NHTSA VIN API
    """

    url = f"https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/{vin}?format=json"

    try:
        response = requests.get(url, timeout=10)
        data = response.json()
    except Exception:
        return {"error": "VIN API request failed"}

    if "Results" not in data or not data["Results"]:
        return {"error": "Invalid VIN or no data found"}

    info = data["Results"][0]

    return {
        "VIN": vin,
        "Make": info.get("Make"),
        "Model": info.get("Model"),
        "ModelYear": info.get("ModelYear"),
        "VehicleType": info.get("VehicleType"),
        "BodyClass": info.get("BodyClass"),
        "FuelType": info.get("FuelTypePrimary"),
        "EngineCylinders": info.get("EngineCylinders"),
        "Manufacturer": info.get("Manufacturer"),
        "PlantCountry": info.get("PlantCountry")
    }
