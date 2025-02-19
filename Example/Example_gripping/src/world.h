#ifndef WORLD_H
#define WORLD_H

#include "eigenIncludes.h"

// include input file and option
#include "setInput.h"

// include elastic Plate class
#include "elasticPlate.h"

// include time stepper
#include "timeStepper.h"

// include force
#include "inertialForce.h"
#include "externalGravityForce.h"
#include "dampingForce.h"
#include "elasticStretchingForce.h"
#include "elasticBendingForce.h"
#include "elasticTwistingForce.h"
#include "elasticStretchingBound.h"
#include "elasticBendingBound.h"
#include "elasticTwistingBound.h"
#include "elasticAngleBound.h"
#include "externalContactForceBody.h"

class world
{
public:
	world();
	world(setInput &m_inputData);
	~world();
	
	bool isRender();
	
	// file output
	void OpenFile(ofstream &outfile);
	void CloseFile(ofstream &outfile);
	void CoutData(ofstream &outfile);

	void setPlateStepper();

	void updateTimeStep();

	int simulationRunning();

	int numStretchingPair();
	Vector3d getScaledCoordinate(int i, int j);

	int numBendingPair();
	Vector3d getBoundaryCoordination_left(int i, int j);
	Vector3d getBoundaryCoordination_right(int i, int j);

	Vector3d getScaledCoordinatePoint();
	double getBoxSize();

private:

	// physical parameters
	bool render;
	bool saveData;
	double deltaTime;
	double totalTime;
	double YoungM;
	double density;
	double Possion;
	double stol;
	double forceTol;
	double scaleRendering;
	int maxIter;
	Vector3d gVector;
	double viscosity;
	double rodRadius;

	double boxSize;
    double stiffness;
    double dBar;
	
	int Nstep;
	int timeStep;

	double characteristicForce;

	double currentTime;

	void plateBoundaryCondition();

	// Plate
	elasticPlate *plate;

	// stepper
	timeStepper *stepper;

	// force
	inertialForce *m_inertialForce;
	externalGravityForce *m_gravityForce;
	dampingForce *m_dampingForce;
	elasticStretchingForce *m_stretchForce;
	elasticBendingForce *m_bendingForce;
	elasticTwistingForce *m_twistingForce;
	elasticStretchingBound *m_elasticStretchingBound;
	elasticBendingBound *m_elasticBendingBound;
	elasticTwistingBound *m_elasticTwistingBound;
	elasticAngleBound *m_elasticAngleBound;
	externalContactForceBody *m_externalContactForceBody;

	VectorXi indexArray;

	void updateEachStep();
};

#endif
