using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpinningLights : MonoBehaviour
{
    public float spinSpeed = 20f;


    void Update()
    {
        transform.localEulerAngles += Vector3.up * spinSpeed * Time.deltaTime;
    }
}
