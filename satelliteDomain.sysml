package CommunicationsSatelliteSystemDomain {

    private import ScalarValues::*;
   
    // =====================================
    // COMMON SYSTEM ELEMENTS
    // =====================================
   
    abstract part def Domain;
    abstract part def SystemEntity;
    abstract part def EnvironmentalFactor;
    abstract part def PhysicalInterface;
    abstract item def EnergySource;
    abstract item def SignalSource;
   
    part def SatelliteSystem {
        timeslice developmentStage;
        then timeslice productionStage{
            ref part assemblyFixtures : ProductionDomain::AssemblyFixture[*];
        }
        then timeslice transitionStage{
            timeslice transportStage{
                attribute shockLevel : Real;
                attribute vibrationLevel : Real;
                attribute accelerationConstraint : Real;
                ref part roadTransport;
                ref part airTransport;
                ref part seaTransport;
            }
            then timeslice launchStage {
                //attributes in the transition at the launch stage
                attribute vibrationSpectrum;
                attribute acousticLevel : Real;
                attribute temperatureTransient;
                attribute pressureProfile;
                ref part launchVehicle : DeliveryDomain::LaunchVehicle;
            }
            then timeslice atmosphericEnvironmentStage{
                //attributes in the transition at the atmosphere stage
                attribute windSpeed : Real;
                attribute windDirection : Real;
                attribute precipitation : Real;
                attribute lightningActivity : Real;
                attribute atmosphericDensity : Real;
                ref part launchVehicle : DeliveryDomain::LaunchVehicle;
            }
            then timeslice earlyOrbitEnvironmentStage{
                //attributes in the transition at the early orbit stage
                attribute vacuumExposure;
                attribute thermalShock;
                attribute solarExposure;
                attribute micrometeoroidFlux;
                ref part LaunchVehicle : DeliveryDomain::LaunchVehicle;
            }
            then timeslice spaceEnvironmentStage{
                //attributes in the transition at the space stage
                attribute orbitGeometry;
                attribute earthAlbedo;
                attribute magneticField;
                attribute atmosphericDrag;
                ref part LaunchVehicle : DeliveryDomain::LaunchVehicle;
            }
        }
        then timeslice operationalStage{
            //attributes in the operational stage
            attribute continuousSpaceExposure;
            attribute cyclicStresses[*];
            attribute cumulativeRadiationDose;
            attribute thermalFatigue;
            attribute internalHeatSources[*];
            attribute thermalCycling;
            attribute spacecraftCharging;
            attribute electrostaticDischarge;
            timeslice maintenanceSage[*]{
                //attributes in the maintenance stage
                attribute uvDegradation : Real;
                attribute thermalCyclingDamage : Real;
                attribute radiationDamage : Real;
                attribute micrometeoriteErosion : Real;
                attribute outgassing : Real;
                attribute componentWearOut;
                attribute solarArrayDegradation;
                attribute batteryCapacityLoss;
                attribute thrusterPerformanceLoss;
            }
        }
        then timeslice decommissionStage{
            //attributes in the decommissioning stage
            attribute spaceDebrisGeneration;
            attribute atmosphericContamination;
            attribute groundImpactRisk;
            attribute radioactiveContamination;
        }

        part communicationPayload;
        part platformSubsystems;
        part structuralElements;
       
        attribute systemMass : Real;
        attribute systemVolume : Real;
        attribute operatingTemperatureRange : Real[2];
        attribute radiationTolerance : Real;
    }
   
    // =====================================
    // DEVELOPMENT DOMAIN
    // =====================================
   
    package DevelopmentDomain {
       
        // Physical test interfaces and measurement systems
        part def TestInterface :> PhysicalInterface {
            attribute interfaceType : TestInterfaceType;
            attribute accessibilityLevel : Real;
        }
       
        enum def TestInterfaceType {
            ElectricalTestPoint;
            MechanicalTestFixture;
            ThermalProbe;
            OpticalAlignment;
            RFTestPort;
            DataBus;
        }
       
        part def MeasurementReferencePoint :> SystemEntity {
            attribute coordinateSystem : CoordinateSystem;
            attribute tolerance : Real;
            attribute measurabilityConstraint : String;
        }
       
        enum def CoordinateSystem {
            BodyFixed;
            LaunchVehicleInterface;
            AntennaFrame;
            SolarArrayFrame;
            ThrusterFrame;
        }
       
        part def DevelopmentEnvironment :> Domain {
            part cleanRoom :> testChamber;
            part testChamber : TestChamber;
            part vibrationTable :> testChamber;
            part thermalVacuum :> testChamber;
            part anechoicChamber :> testChamber;
           
            attribute contaminationLevel : Real;
            attribute ambientConditions;
        }
       
        part def TestChamber :> EnvironmentalFactor {
            attribute pressureRange : Real[2];
            attribute temperatureRange : Real[2];
            attribute humidityRange : Real[2];
            attribute vibrationSpectrum;
        }
       
        part def CalibrationSource :> SignalSource {
            attribute sourceType : CalibrationSourceType;
            attribute frequency : Real;
            attribute amplitude : Real;
            attribute stability : Real;
        }
       
        enum def CalibrationSourceType {
            RFSignalGenerator;
            OpticalCalibrator;
            PrecisionVoltageSource;
            FrequencyStandard;
            NoiseSource;
        }
       
        part def DiagnosticInterface :> PhysicalInterface {
            part dataAcquisitionPortst[*];
            part powerMonitoringPoints[*];
            part temperatureSensors[*];
            part pressureTapPoints[*];
        }
       
        part def PrototypeComponents :> SystemEntity {
            part breadboardCircuits[*];
            part engineeringModels[*];
            part mockupStructures[*];
           
            attribute fidelityLevel : FidelityLevel;
        }
       
        enum def FidelityLevel {
            Conceptual;
            Breadboard;
            EngineeringModel;
            QualificationModel;
            FlightModel;
        }
       
        // Development-stage physical constraints
        part def HandlingFixture :> PhysicalInterface {
            attribute liftPoint[*];
            attribute supportSurface;
            attribute accessibilityConstraint;
        }
       
        part def DevelopmentPowerSource :> EnergySource {
            attribute voltageLevel : Real;
            attribute currentCapacity : Real;
            attribute regulationAccuracy : Real;
            attribute ripple : Real;
        }
    }
   
    // =====================================
    // PRODUCTION DOMAIN
    // =====================================
   
    package ProductionDomain {
       
        part def ManufacturingEnvironment :> Domain {
            part assemblyFixtures : AssemblyFixture[*];
            part cleanroomZones[*];
            part temperatureControlledAreas[*];
            part electrostaticProtectionZones[*];
           
            attribute particleContamination : Real;
            attribute molecularContamination : Real;
            attribute electrostaticCharge : Real;
        }
       
        part def AssemblyFixture :> PhysicalInterface {
            attribute fixtureType : AssemblyFixtureType;
            attribute positioningAccuracy : Real;
            attribute loadCapacity : Real;
            attribute accessAngles : Real[*];
        }
       
        enum def AssemblyFixtureType {
            RotationFixture;
            IntegrationStand;
            AlignmentJig;
            WeldingFixture;
            BondingPlatform;
        }
       
        part def QualityInspectionSystem :> SystemEntity {
            part dimensionalMeasurement;
            part xrayInspection;
            part ultrasonicTesting;
            part opticalInspection;
        }
       
        part def ComponentSupplyChain :> SystemEntity {
            part rawMaterials[*];
            part electronicComponents[*];
            part mechanicalComponents[*];
            part chemicalSubstances[*];
           
            attribute traceabilityCode : String;
            attribute qualityGrade : QualityGrade;
        }
       
        enum def QualityGrade {
            Commercial;
            Industrial;
            Military;
            Space;
            SpaceHeritage;
        }
       
        part def ProductionTooling :> PhysicalInterface {
            part cuttingTools[*];
            part weldingEquipment[*];
            part bondingEquipment[*];
            part cleaningStations[*];
        }
       
        part def TestingInfrastructure :> SystemEntity {
            part functionalTestSets[*];
            part environmentalTestChambers[*];
            part performanceTestEquipment[*];
           
            attribute testCoverage : Real;
            attribute measurementUncertainty : Real;
        }
       
        part def MaterialHandlingSystem :> SystemEntity {
            part transportMechanisms[*];
            part storageContainers[*];
            part liftingEquipment[*];
           
            attribute contaminationControl : Boolean;
        }
       
        part def ProductionWasteStreams :> EnvironmentalFactor {
            item solidWaste;
            item liquidWaste;
            item gasEmissions;
            item chemicalByproducts[*];
        }
    }
   
    // =====================================
    // DELIVERY DOMAIN
    // =====================================
   
    package DeliveryDomain {
       
        part def LaunchVehicle :> SystemEntity {
            ref part SatelliteSystem;
            part payloadFairing;
            part separationMechanism;
            part payloadAttachFitting;
           
            attribute accelerationProfile;
            attribute vibrationEnvironment;
            attribute acousticEnvironment;
        }
       
        part def TransportationEnvironment :> Domain {
            part roadTransport{
                ref part SatelliteSystem;
            }
            part airTransport{
                ref part SatelliteSystem;
            }
            part seaTransport{
                ref part SatelliteSystem;
            }
           
            attribute shockLevel : Real;
            attribute vibrationLevel : Real;
            attribute accelerationConstraint : Real;
        }
       
        part def LaunchSiteInfrastructure :> Domain {
            part LaunchVehicle : LaunchVehicle;
            part processingFacility : ProcessingFacility;
            part fuelingStations[*];
            part electricalGroundSupport;
            part purgeGasSupply;
            part communicationLinks[*];
        }
       
        part def ProcessingFacility :> EnvironmentalFactor {
            attribute cleanlinessLevel : Real;
            attribute temperatureStability : Real;
            attribute humidityControl : Real;
            attribute accessControlLevel;
        }
       
        part def GroundSupportEquipment :> SystemEntity {
            part umbilicalConnectors[*];
            part servicingPorts[*];
            part monitoringProbes[*];
            part purgeConnections[*];
           
            attribute disconnectionSequence;
        }
    }
   
    // =====================================
    // OPERATIONS DOMAIN
    // =====================================
   
    package OperationsDomain {
       
        part def SpaceEnvironment :> Domain {
            ref part SatelliteSystem;
            part sun : Sun;
            part micrometeoroidDebris;
            part magnetosphericEnvironment;
            part communicationPartners : CommunicationPartners[*];
           
            attribute vacuumLevel : Real;
            attribute temperatureCycling;
            attribute galacticCosmicRays;
            attribute trappedRadiation;
            attribute totalIonizingDose : Real;
            attribute singleEventUpset;
            //Radiofrequency attributes
            attribute interferenceSource[*];
            attribute atmosphericNoise;
            attribute ionosphericEffects;
            attribute rainAttenuation;     
            attribute spectrumOccupancy;
            attribute regulatoryConstraints[*];
        }
       
        item def Sun :> EnergySource {
            attribute solarConstant : Real; // W/m²
            attribute solarCycleVariation : Real;
            attribute eclipseGeometry;
            attribute solarFlareActivity;
            attribute solarEnergeticParticles;
            attribute solarRadiationPressure;
            attribute solarHeating;
        }
       
        part def CommunicationPartners :> SystemEntity {
            part groundStations : GroundStation[*];
            part relayStations : GroundStation[*];
            part otherSatellites : SatelliteSystem[*];
        }
       
        part def GroundStation :> SystemEntity {
            part antennaSystem;
            part rfSubsystem;
            part baseband;
           
            attribute elevationMask : Real;
            attribute linkMargin : Real;
            attribute trackingAccuracy : Real;
            attribute geographicLocation;
        }
       
        part def earth {
            attribute gravitationalField;
            attribute atmosphericDrag;
            attribute thirdBodyPerturbations[*];
            attribute stationKeepingRequirements;
            attribute earthInfraredRadiation;
            attribute thermalCycling;
            attribute earthAlbedoReflection;
            attribute magneticFieldVariation;
        }
       
        part def NavigationReferences :> SystemEntity {
            part gnssConstellations[*];
            part celestialReferences[*];
            part groundBeacons[*];
            part inertialReferences[*];
        }
    }
   
    // =====================================
    // MAINTENANCE DOMAIN
    // =====================================
   
    package MaintenanceDomain {
       
        part def DiagnosticSystems :> SystemEntity {
            part healthMonitoringSensors : HealthSensor[*];
            part builtInTestEquipment[*];
            part telemetrySystem;
            part dataRecorders[*];
        }
       
        part def HealthSensor :> SystemEntity {
            attribute sensorType : HealthSensorType;
            attribute measurementRange : Real[2];
            attribute accuracy : Real;
            attribute samplingRate : Real;
        }
       
        enum def HealthSensorType {
            Temperature;
            Voltage;
            Current;
            Vibration;
            Pressure;
            FlowRate;
            Position;
            SpinRate;
        }
       
        part def MaintenanceInterfaces :> PhysicalInterface {
            part reconfigurationSwitches[*];
            part redundantPaths[*];
            part bypassModes[*];
            part safeMode;
        }
       
        part def RemainingConsumables :> SystemEntity {
            part propellantReserves[*];
            part batteryCapacity;
            part lubricants;
            part coolants;
           
            attribute remainingLifetime : Real;
        }
       
        part def WearIndicators :> SystemEntity {
            part mechanicalWearIndicator[*];
            part electricalPerformanceIndicator[*];
            part thermalPerformanceIndicator[*];
            part signalQualityIndicator[*];
        }
       
        part def AutonomousMaintenanceSystems :> SystemEntity {
            part faultDetectionSystem;
            part faultIsolationSystem;
            part automaticReconfigurationSystem;
            part performanceOptimizationSystem;
        }
    }
   
    // =====================================
    // DECOMMISSION DOMAIN
    // =====================================
   
    package DecommissionDomain {
       
        part def EndOfLifeEnvironment :> Domain {
            ref part SatelliteSystem;
            part graveyardOrbit : GraveyardOrbitEnvironment;
            part atmosphericReentryEnvironment : ReentryEnvironment;
            part deepSpaceEnvironment;
            part debrisField;
        }
       
        part def GraveyardOrbitEnvironment :> EnvironmentalFactor {
            attribute orbitAltitude : Real;
            attribute orbitStability : Real;
            attribute collisionProbability : Real;
            attribute perturbationForces[*];
        }
       
        part def ReentryEnvironment :> EnvironmentalFactor {
            attribute atmosphericDensityProfile;
            attribute heatingProfile;
            attribute aerodynamicForces;
            attribute breakupAltitude : Real;
            attribute impactFootprint;
        }
       
        part def PassivationSystems :> SystemEntity {
            part fuelVentingSystem;
            part batteryPassivationSystem;
            part pressureVessels[*];
            part energyStorageSystems[*];
           
            attribute passivationCompleteness : Real;
        }
       
        part def DecommissionInterfaces :> PhysicalInterface {
            part propulsionShutdownSystem;
            part powerSystemShutdownSystem;
            part payloadShutdownSystem;
            part safetyIsolationSystem;
        }
       
        part def RemainingResources {
            item residualFuel;
            item storedEnergy;
            item pressurizedFluids [*];
            item radioactiveMaterials[*];
           
            attribute hazardLevel : HazardLevel;
        }
       
        enum def HazardLevel {
            Minimal;
            Low;
            Moderate;
            High;
            Extreme;
        }
       
        part def DisposalForces :> EnvironmentalFactor {
            part naturalPerturbations[*];
            part artificialPerturbations[*];
        }
       
        part def MonitoringSystems :> SystemEntity {
            part trackingBeacons[*];
            part positionReportingSystem;
            part statusTelemetrySystem;
            part emergencyBeacons[*];
        }
    }
   
}