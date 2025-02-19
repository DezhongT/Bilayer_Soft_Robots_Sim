#include "dampingForce.h"

dampingForce::dampingForce(elasticPlate &m_plate, timeStepper &m_stepper, double m_viscosity)
{
	plate = &m_plate;
    stepper = &m_stepper;

	viscosity = m_viscosity;

	c1 = viscosity;
	c2 = viscosity * 100;
}

dampingForce::~dampingForce()
{
	;
}

void dampingForce::computeFd()
{
	for (int i = 0; i < 160; i++)
	{
		int index1 = plate->v_edgeElement[i].nv_1;
		int index2 = plate->v_edgeElement[i].nv_2;

		double len = plate->v_edgeElement[i].refLength0;

		Vector3d x1 = plate->getVertex(index1);
		Vector3d x2 = plate->getVertex(index2);

		Vector3d u1 = plate->getVelocity(index1);
		Vector3d u2 = plate->getVelocity(index2);

		Vector3d tangent = (x2 - x1) / (x2 - x1).norm();
		Vector3d normal = plate->v_edgeElement[i].d2;

		Vector3d velocity = (u2 + u1) / 2;

		double vn = normal.dot(velocity);
		if (vn < 0)
		{
			vn = -vn;
			normal = -normal;
		}

		double vt = tangent.dot(velocity);
		if (vt < 0)
		{
			vt = - vt;
			tangent = - tangent;
		}

		Vector3d force = - 0.5 * 1000 * len * (c1 * vt * (vt) * tangent + c2 * vn * (vn) * normal);
		
		for (int k = 0; k < 3; k++)
		{
			int ind = 3 * index1 + k;
			
			stepper->addForce(ind, - force[k]/2);
		}

		for (int k = 0; k < 3; k++)
		{
			int ind = 3 * index2 + k;
			
			stepper->addForce(ind, - force[k]/2);
		}
	}
}

void dampingForce::computeJd()
{
	for (int i = 0; i < 160; i++)
	{
		int index1 = plate->v_edgeElement[i].nv_1;
		int index2 = plate->v_edgeElement[i].nv_2;

		double len = plate->v_edgeElement[i].refLength0;

		Vector3d x1 = plate->getVertex(index1);
		Vector3d x2 = plate->getVertex(index2);

		Vector3d u1 = plate->getVelocity(index1);
		Vector3d u2 = plate->getVelocity(index2);

		Vector3d tangent = (x2 - x1) / (x2 - x1).norm();
		Vector3d normal = plate->v_edgeElement[i].d2;

		Vector3d velocity = (u2 + u1) / 2;

		double vn = normal.dot(velocity);
		if (vn < 0)
		{
			vn = -vn;
			normal = -normal;
		}

		double vt = tangent.dot(velocity);
		if (vt < 0)
		{
			vt = - vt;
			tangent = - tangent;
		}

		Matrix3d jac = 1000 * len * (c1 * vt * tangent * tangent.transpose() + c2 * vn * normal * normal.transpose() ) / plate->dt;

		
		for(int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 3; k++)
			{
				int ind1 = 3 * index1 + j;
				int ind2 = 3 * index1 + k;

				stepper->addJacobian(ind1, ind2, jac(j, k) / 2);
			}
		}

		for(int j = 0; j < 3; j++)
		{
			for (int k = 0; k < 3; k++)
			{
				int ind1 = 3 * index2 + j;
				int ind2 = 3 * index2 + k;

				stepper->addJacobian(ind1, ind2, jac(j, k) / 2);
			}
		}

	}
}

void dampingForce::setFirstJacobian()
{
	for (int i = 0; i < plate->nv; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			int ind = 3 * i + j;
			stepper->addJacobian(ind, ind, 1);
		}
	}
}
